<#
Author:
Reference:https://github.com/Sw4mpf0x/PowerLurk

* 　　 ┏┓     ┏┓
* 　　┏┛┻━━━━━┛┻┓
* 　　┃　　　　　 ┃
* 　　┃　　━　　　┃
* 　　┃　┳┛　┗┳  ┃
* 　　┃　　　　　 ┃
* 　　┃　　┻　　　┃
* 　　┃　　　　　 ┃
* 　　┗━┓　　　┏━┛　Code is far away from bug with the animal protecting
* 　　　 ┃　　　┃    神兽保佑,代码无bug
* 　　　　┃　　　┃
* 　　　　┃　　　┗━━━┓
* 　　　　┃　　　　　　┣┓
* 　　　　┃　　　　　　┏┛
* 　　　　┗┓┓┏━┳┓┏┛
* 　　　　 ┃┫┫ ┃┫┫
* 　　　　 ┗┻┛ ┗┻┛
#>

function RegEventSubscription{
	Param (
		[String] $EventFilterName,
		[String] $EventConsumerName,
		[String] $CommandLineTemplate,
		[String] $Trigger,
		[String] $ProcessName,
		[String] $UserName,
		[String] $Domain,
		[String] $TimerId,
		[String] $RunType,
		
		#Scripting Type 		
		[ValidateSet('VBScript', 'JScript')]
        [String]
        [ValidateNotNullOrEmpty()]
        $ScriptingEngine,
		
		[String]
        [ValidateNotNullOrEmpty()]
        $PermanentScript,
		
		[ScriptBlock]
        [ValidateNotNullOrEmpty()]
        $LocalScriptBlock,
		
		[Int32]
        $IntervalPeriod,
		[Datetime]
        $ExecutionTime
		
	)
	if($NamespaceName){
		Write-Host "[*] NamespaceName: $NamespaceName"
	}else{
		$NamespaceName = "root/subscription"
		Write-Host "[*] NamespaceName: $NamespaceName"
	}
	
	if($Trigger ){
		Write-Host "[*] Trigger: $Trigger"
	}
	if($EventFilterName)
	{
		Write-Host "[*] Event Filter: $EventFilterName"
	}
	if($EventConsumerName){
		Write-Host "[*] Event Consumer: $EventConsumerName"	
	}
	
	if($Domain){
		Write-Host "[*] Domain: $Domain"
	}
	if($UserName){
		Write-Host "[*] UserName: $UserName"
	}
	if($ProcessName){
		Write-Host "[*] ProcessName: $ProcessName"
	}
	if($IntervalPeriod){
		Write-Host "[*] IntervalPeriod: $IntervalPeriod"
	}
	if($TimerId){
		Write-Host "[*] TimerId: $TimerId"
	}
	if($ExecutionTime){
		Write-Host "[*] ExecutionTime: $ExecutionTime"
		$New = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime($ExecutionTime);
		$news = [System.Management.ManagementDateTimeConverter]::ToDateTime($New)
		Write-Host "[*] NewExecutionTime: $New"
		Write-Host "[*] news: $news"
	}
	
	if( $ScriptingEngine){
		Write-Host "[*] ScriptingEngine: $ScriptingEngine"
	}

	$Arguments = @{}
	try {
	Switch ($Trigger){
        'InsertUSB' {$Query = 'SELECT * FROM Win32_VolumeChangeEvent WHERE EventType = 2'}
		'UserLogon' {
            if ($UserName -eq 'any' -or $UserName -eq '*'){
                $Query = "SELECT * FROM __InstanceCreationEvent WITHIN 15 WHERE TargetInstance ISA 'Win32_LogonSession' AND TargetInstance.LogonType = 2"
            }else{
                $Query = "SELECT * FROM __InstanceCreationEvent WITHIN 15 WHERE TargetInstance ISA 'Win32_LogonSession' AND TargetInstance.LogonType = 2 AND TargetInstance.__RELPATH like `"%$Domain%$UserName%`""             
            }
        }
        'Interval' {
			trap [exception]
			{
				$_.Exception.Message
				continue
			}
			$ErrorActionPreference='stop'
			
			Try{
				Set-WmiInstance -class '__IntervalTimerInstruction' -Arguments @{ IntervalBetweenEvents = ($IntervalPeriod * 1000); TimerId = $TimerId } | Out-Null
				$Query = "Select * from __TimerEvent where TimerId = '$TimerId'"
			}Catch{
				$InerrMessage = $_.FullyQualifiedErrorId 
				Write-Host '[-] FullyQualifiedErrorId:' $InerrMessage
				return
			}
			
        }
        'Timed' {
            Set-WmiInstance -class '__AbsoluteTimerInstruction' -Arguments @{ EventDatetime = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime($ExecutionTime); TimerId = $TimerId } | Out-Null
            $Query = "Select * from __TimerEvent where TimerId = '$TimerId'"
        }
        'ProcessStart' {
            $Query = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='$ProcessName'"
        }
		'Reboot'{
			$Query= "SELECT * FROM __InstanceModificationEvent WITHIN 90 WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' AND TargetInstance.SystemUpTime >= 240 AND TargetInstance.SystemUpTime < 325"
		}
        
		default  {
			Write-Host "[-] Error,Trigger：$Trigger No define."
			return
		}
    }
	}
	catch {
        Write-Warning $_
    }
	
	Switch ($RunType){
		'CommandLine'{
			if($CommandLineTemplate){
				Write-Host "[*] CommandLineTemplate: $CommandLineTemplate"
			}else{
				Write-Host "[-] No CommandLine."
				return
			}
			$CommandLineConsumerArgs = @{
				Name = $EventConsumerName
				CommandLineTemplate = $CommandLineTemplate
			}
			$Consumer = Set-WmiInstance -Namespace $NamespaceName -Class CommandLineEventConsumer -Arguments $CommandLineConsumerArgs
			
			$EventFilterArgs = @{
				EventNamespace = 'root/cimv2'
				Name = $EventFilterName
				Query = $Query
				QueryLanguage = 'WQL'
			}				
			$Filter = Set-WmiInstance -Namespace $NamespaceName -Class __EventFilter -Arguments $EventFilterArgs @Arguments
		 
			$FilterToConsumerArgs = @{
				Filter = $Filter
				Consumer = $Consumer
			}
			$FilterToConsumerBinding = Set-WmiInstance -Namespace $NamespaceName -Class __FilterToConsumerBinding -Arguments $FilterToConsumerArgs
			
			$EventCheck = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
			if ($EventCheck -ne $null) {
				Write-Host "[+] Event Filter $EventFilterName successfully written to host"
			}else{
				Write-Host "[-] Error,Event Filter $EventFilterName Failed written to host"
			}
		 
			$ConsumerCheck = Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer -Filter "Name = '$EventConsumerName'"
			if ($ConsumerCheck -ne $null) {
				Write-Host "[+] Event Consumer $EventConsumerName successfully written to host."
			}else{
				Write-Host "[-] Error,Event Consumer $EventConsumerName Failed written to host."
				$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
				$EventFilterToCleanup | Remove-WmiObject
				Write-Host "[*] Remove $EventFilterName Done."
			}
		 
			$BindingCheck = Get-WmiObject -Namespace $NamespaceName -Class __FilterToConsumerBinding -Filter "Filter = ""__eventfilter.name='$EventFilterName'"""
			if ($BindingCheck -ne $null){
				Write-Host "[+] Filter To Consumer Binding successfully written to host"
			}else{
				Write-Host "[-] Error,Filter To Consumer Binding Failed written to host."
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer -Filter "Name = '$EventConsumerName'"
				$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
				$FilterConsumerBindingToCleanup = Get-WmiObject -Namespace $NamespaceName -Query "REFERENCES OF {$($EventConsumerToCleanup.__RELPATH)} WHERE ResultClass = __FilterToConsumerBinding"
				$FilterConsumerBindingToCleanup | Remove-WmiObject
				$EventConsumerToCleanup | Remove-WmiObject
				$EventFilterToCleanup | Remove-WmiObject
				Write-Host "[*] Remove Consumer：$EventConsumerName,Event Filter：$EventFilterName,Done."
			}
		}
		'ActiveScript'{
			if($PermanentScript){
				Write-Host "[*] PermanentScript: $PermanentScript"
			}else{
				Write-Host "[-] No PermanentScript."
				return
			}
			$EventFilterArgs = @{
				EventNamespace = 'root/cimv2'
				Name = $EventFilterName
				Query = $Query
				QueryLanguage = 'WQL'
			}				
			$Filter = Set-WmiInstance -Namespace $NamespaceName -Class __EventFilter -Arguments $EventFilterArgs @Arguments
			
			$ScriptConsumerArgs = @{
                Name = $EventConsumerName
                ScriptText = $PermanentScript
                ScriptingEngine = $ScriptingEngine
            }
            $Consumer = Set-WmiInstance -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Arguments $ScriptConsumerArgs @Arguments
            
			$FilterToConsumerArgs = @{
				Filter = $Filter
				Consumer = $Consumer
			}

			$FilterToConsumerBinding = Set-WmiInstance -Namespace $NamespaceName -Class __FilterToConsumerBinding -Arguments $FilterToConsumerArgs @Arguments | Out-Null
			
			$EventCheck = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
			if ($EventCheck -ne $null) {
				Write-Host "[+] Event Filter $EventFilterName successfully written to host"
			}else{
				Write-Host "[-] Error,Event Filter $EventFilterName Failed written to host"
			}

			$ConsumerCheck = Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Filter "Name = '$EventConsumerName'"
			if ($ConsumerCheck -ne $null) {
				Write-Host "[+] Event Consumer $EventConsumerName successfully written to host."
			}else{
				Write-Host "[-] Error,Event Consumer $EventConsumerName Failed written to host."
				$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
				$EventFilterToCleanup | Remove-WmiObject
				Write-Host "[*] Remove $EventFilterName Done."
			}
		 
			$BindingCheck = Get-WmiObject -Namespace $NamespaceName -Class __FilterToConsumerBinding -Filter "Filter = ""__eventfilter.name='$EventFilterName'"""
			if ($BindingCheck -ne $null){
				Write-Host "[+] Filter To Consumer Binding successfully written to host"
			}else{
				Write-Host "[-] Error,Filter To Consumer Binding Failed written to host."
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Filter "Name = '$EventConsumerName'"
				$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
				$FilterConsumerBindingToCleanup = Get-WmiObject -Namespace $NamespaceName -Query "REFERENCES OF {$($EventConsumerToCleanup.__RELPATH)} WHERE ResultClass = __FilterToConsumerBinding"
				$FilterConsumerBindingToCleanup | Remove-WmiObject
				$EventConsumerToCleanup | Remove-WmiObject
				$EventFilterToCleanup | Remove-WmiObject
				Write-Host "[*] Remove Consumer：$EventConsumerName,Event Filter：$EventFilterName,Done."
			}            
		}

		'LocalScriptBlock'{
			Write-Host "[*] Query： $Query"
			Write-Host "[*] LocalScriptBlock： $LocalScriptBlock"
			Write-Host "[*] EventName： $EventFilterName"
            $Arguments = @{
                Query = $Query
                Action = $LocalScriptBlock
                SourceIdentifier = $EventFilterName
            }
			Register-CimIndicationEvent @Arguments
        }
		else{
			Write-Host "[-] Not Found RunType."
		}
    }
}
 
function CleanEventSubscription{
	Param (
		[String] $EventFilterName,
		[String] $RunType,
		[String] $EventConsumerName,
		
		[String]
		$BindingTo,
		
		[String]
        $NamespaceName
	)
	
	if($NamespaceName){
		Write-Host "[*] NamespaceName: $NamespaceName"
	}else{
		$NamespaceName = "root/subscription"
		Write-Host "[*] NamespaceName: $NamespaceName"
	}

	Switch ($RunType){
		'CommandLine'{
			if($EventConsumerName){
				Write-Host "[*] Clean CommandLineEventConsumer: $EventConsumerName"	
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer -Filter "Name = '$EventConsumerName'"
			}else{
				Write-Host "[*] Clean All CommandLineEventConsumer"	
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer
			}
        }
		'ActiveScript'{
			if($EventConsumerName){
				Write-Host "[*] Clean ActiveScriptEventConsumer: $EventConsumerName"	
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Filter "Name = '$EventConsumerName'"
			}else{
				Write-Host "[*] Clean All ActiveScriptEventConsumer"	
				$EventConsumerToCleanup = Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer
			}
        }
	}
	
	if($EventFilterName)
	{
		Write-Host "[*] Clean Event Filter: $EventFilterName"
		$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name = '$EventFilterName'"
	}else{
		Write-Host "[*] Clean All EventFilterName"
		$EventFilterToCleanup = Get-WmiObject -Namespace $NamespaceName -Class __EventFilter
	}
	
	if($BindingTo -eq 'Any'){
		Write-Host "[*] Clean All FilterToConsumerBinding"
		$FilterConsumerBindingToCleanup = Get-WMIObject -Namespace $NamespaceName -Class __FilterToConsumerBinding 
	}else{
		Write-Host "[*] Clean FilterToConsumerBinding __Path LIKE '%$EventFilterName%'"
		$FilterConsumerBindingToCleanup = Get-WMIObject -Namespace $NamespaceName -Class __FilterToConsumerBinding -Filter "__Path LIKE '%$EventFilterName%'"
	}

    $FilterConsumerBindingToCleanup | Remove-WmiObject
    $EventConsumerToCleanup | Remove-WmiObject
    $EventFilterToCleanup | Remove-WmiObject
	Write-Host "[*] Function CleanEventSubscription Done."
}
 
function ShowEventSubscription{
	Param (
		[String] $EventFilterName,
		[String] $RunType,
		[String] $EventConsumerName,
		
		[String]
		$BindingTo,
		
		[String]
        $NamespaceName
	)

	if($NamespaceName){
		Write-Host "[*] NamespaceName: $NamespaceName"
	}else{
		$NamespaceName = "root/subscription"
		Write-Host "[*] NamespaceName: $NamespaceName"
	}

	if($EventFilterName)
	{
		Write-Host "[*] Showing $EventFilterName Event Filters"
		Get-WmiObject -Namespace $NamespaceName -Class __EventFilter -Filter "Name LIKE '%$EventFilterName%'"
	}else{
		Write-Host "[*] Showing All Root Event Filters"
		Get-WmiObject -Namespace $NamespaceName -Class __EventFilter
	}

	Switch ($RunType){
		'CommandLine'{
			if($EventConsumerName){
				Write-Host "[*] Showing CommandLine Event Consumers:$EventConsumerName"	
				Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer -Filter "Name LIKE '%$EventConsumerName%'"
			}else{
				Write-Host "[*] Showing All CommandLine Event Consumers"
				Get-WmiObject -Namespace $NamespaceName -Class CommandLineEventConsumer
			}
        }
		'ActiveScript'{
			if($EventConsumerName){
				Write-Host "[*] Showing ActiveScript Event Consumers:$EventConsumerName"	
				Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Filter "Name LIKE '%$EventConsumerName%'"
			}else{
				Write-Host "[*] Showing All ActiveScript Event Consumers"	
				Get-WmiObject -Namespace $NamespaceName -Class ActiveScriptEventConsumer -Filter "Name LIKE '%$EventConsumerName'"
			}
        }
	}

	if($BindingTo -eq 'Any'){
		Write-Host "[*] Showing All Filter to Consumer Bindings"
		Get-WmiObject -Namespace $NamespaceName -Class __FilterToConsumerBinding
	}else{
		Write-Host "[*] Showing FilterToConsumerBinding __Path LIKE '%$EventFilterName%'"
		Get-WMIObject -Namespace $NamespaceName -Class __FilterToConsumerBinding -Filter "__Path LIKE '%$EventFilterName%'"
	}
}