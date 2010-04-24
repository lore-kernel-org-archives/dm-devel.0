From: brem belguebli <brem.belguebli@gmail.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Sat, 24 Apr 2010 13:53:19 +0200
Message-ID: <1272109999.2983.30.camel@localhost>
References: <20100422164739.GA15813@lsil.com>
	<1271964275.2480.1.camel@localhost> <4BD1A071.2010202@emulex.com>
	<j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>
	<4BD226F4.6070908@emulex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD226F4.6070908@emulex.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Smart <james.smart@emulex.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi James

On Fri, 2010-04-23 at 19:02 -0400, James Smart wrote:
> 
> brem belguebli wrote:
> > Hello James,
> >
> > And thanks for your reply.
> >
> > Unfortunately, as mentionned nothing was logged nowhere (console,
> > /proc/kmsg, dmesg etc...) , this is what scares me.
> >   
> Yes - that is very odd....
> 
> > During the investigation we launched a script that checks the rports
> > and /dev/sd states, and rports were reported as  Online as well as the
> > /dev/sd devices shown as running.
> >   
> The rport state is maintained by the lpfc driver w/ help from the 
> transport. If they are in an online state, then the driver says it has 
> no outstanding discovery events from the device and it believes it is 
> fully connected (e.g. last plogi/adisc/etc worked fine).  Thus, I/O 
> should be free to flow subject the sd driver and block layer.
> 
> So, if sd then says the device is running, there should be nothing to 
> stop i/o to the device, so it then would say - whats on top of sd that 
> would send i/o - the filesystem, dm, application, etc.  It's starting to 
> sound like it's a DM thing as that would be the only reason the midlayer 
> and driver would show these states, but i/o would not be flowing down 
> that path..
> 
> Note: for the future, with the rport and sd in this state - the best 
> thing to validate connectivity/response from the target would be:
> - obtain the sg3_utils package from http://sg.danny.cz/sg/sg3_utils.html
> - use one of the utilities to send a raw scsi io to the device - I'd 
> recommend sg_inq that just queries who the device is.
> 
We have sg3_utils installed , and I think we ran sg_verify on one or 2
unresponsive /dev/sd and it didn't give the hand back. 

> using the sg utils will bypass the sd driver (although, may use the 
> block io queue associated with it), and tests the path through the scsi 
> midlayer, to the hba, and from the hba to the target/lun.
> 
> 
> > We were really in a black hole thing.
> >
> > Concerning DM configuration (MP ?) we are using what's recommended by
> > HP for this type of storage (EVA8100), cf below:
> >
> > defaults {
> >         polling_interval        10
> >         path_grouping_policy    multibus
> >         getuid_callout          "/sbin/scsi_id -g -u -s  /block/%n"
> >         no_path_retry           fail
> >         user_friendly_names     yes
> >         bindings_file           "/etc/multipath_bindings"
> >
> > }
> > blacklist {
> >         devnode         "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> >         devnode         "^hd[a-z]"
> >         devnode         "^cciss"
> > }
> > devices {
> >           device {
> >                 vendor                  "HP|COMPAQ"
> >                 product                 "HSV1[01]1
> > \(C\)COMPAQ|HSV2[01]0|HSV300|HSV4[05]0"
> >                 path_grouping_policy    group_by_prio
> >                 getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
> >                 path_checker            tur
> >                 path_selector           "round-robin 0"
> >                 prio_callout            "/sbin/mpath_prio_alua /dev/%n"
> >                 rr_weight               uniform
> >                 failback                immediate
> >                 hardware_handler        "0"
> >                 no_path_retry           fail
> >                 rr_min_io               100
> >         }
> > }
> >
> > I don't know if it will help as we did test directly the /dev/sdX
> > devices to bypass DM-MP
> >   
> What do you mean by this ?    something like dd if=/dev/sdX of=/dev/null 
> count=1  ?    I'm not sure, if DM is on top of it, that this really 
> works. Also, dd can respond from the cache anyway and avoid an actual i/o.
> 
It was exactly 
cd /sys/block
for DEV in `ls -1d dev*`; do
echo ${DEV}
	dd if =/dev/${DEV} of=/dev/null bs=1024 count=1 &
	echo
done

And yes it really works, never seen any kind of preemption of DM-MP over
direct sd access. I've cc'ed dm-devel may be some DM guru could give his
opinion on this.

Next time, I'll use a sg_dd instead of dd, to bypass any cache effect
(by the way, does VFS cache anything when addressing /dev/X devices ?)

> I'd like to know the i/o failure if so.
> 
> 
> > /dev/sd devices timers are set to default udev value, 60 seconds.
> >
> > Something that may help is the firmware rev of the HBA's : 2.50A8
> > (Z2F2.50A8), sli-2
> >   
> I'm guessing this firmware is a bit old...
> I see the latest for this adapter should be F/W version 2.72A2 or later
> See Table 9 for 403621-B21 (the LPe1105-HP mez)  at 
> http://docs.hp.com/en/5900-0486_e2/ar01s05.html?jumpid=reg_R1002_USEN
> 
> Here's a link to 2.80a4 (8/14/2009):
> http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareDescription.jsp?lang=en&cc=us&swItem=co-74079-1&jumpid=reg_R1002_USEN
> 
> However, I'm not sure that's the root of the issue.
> 
> Checking the driver rev - the latest for rhel5.3 is 8.2.0.39 available at:
> http://www.emulex.com/downloads/emulex/cnas-and-hbas/drivers/linux.html
> 
> It wouldn't surprise me if the 8.2.0.66 version works as well.  I've 
> attached a ChangeLog for the differences between 33 and 39 - and to 66.
> 
> > San switches are, for the edges Brocade HP blade switches running
> > FABOS 6.2.0.g and core switches are 48000 running the same FABOS
> > version
> >
> > I could activate some intersting debugging on the driver if you point
> > me to the right debug values, as well as for scsi_logging (32 bit
> > possibilities is quite long to calibrate to get the interesting
> > information...)
> >   
> The most interesting for the lpfc driver would be the lpfc module 
> parameter "lpfc_log_verbose=4115"
> which turns on discovery log messages, els messages, link events, and 
> FCP i/o error messages.

As our DWDM ring switch is on the less optimal path, there will be a
switch back to nominal soon.

I'll activate this log level on the HBA's and check the firmware
versions you gave me .

Hopefully, we will be able to provide you something deeper to
investigate.

Brem 
> -- james
> 
> > Regards
> >
> > Brem
> >
> > 2010/4/23 James Smart <james.smart@emulex.com>:
> >   
> >> Brem,
> >>
> >> We're looking at the lpfc driver as to whether this matches anything we are
> >> aware of.
> >>
> >> Please send me the system console log during this time frame. No messages
> >> whatsoever would be very odd.  Sending us the output of the shost, rport,
> >> and sdev sysfs parameters, as well as DM configuration values would also
> >> help. It won't necessarily be i/o timers that would fire, but other timers
> >> should.
> >>
> >> -- james s
> >>
> >>
> >> brem belguebli wrote:
> >>     
> >>> I have a server (RHEL 5.3) connected to 2 SAN extended fabrics (across 2
> >>> sites, distance 1 ms, links are ISL with 100 km long distance buffer
> >>> credits) via 2 lpfc HBA's (LPe1105-HP FC with the RHEL 5.3 shipped LPFC
> >>> driver 8.2.0.33.3p.)
> >>>  A SAN FABRIC reconfiguration (DWDM Ring failover from worker to
> >>> protection)  occured yesterday  after some intersite telco link switch
> >>> that lasted less than 0,3 ms.  Only one FABRIC was impacted, named FABRIC2
> >>>  Our server is connected to the FABRICs thru 2 edge switches, so not
> >>> directly connected to the core switches on which the link failure
> >>> occured.
> >>>       
> >>>> From then, our server (which accesses thru the 2 fabrics the LUNS from
> >>>>         
> >>> our 2 sites) started to climb in terms of load average (up to 250 for a
> >>> dual proc quadcore machine!) with a high percentage of iowait (up to
> >>> 50%).  We did some testing, bypassing DM-MP by issuing dd commands to the
> >>> physical /dev/sdX devices (more than 30 LUNS are presented to the
> >>> server, seen each thru 4 paths making more than 120 /dev/sd devices)
> >>> and half of our dd processes went to D state, as well as some unitary
> >>> scsi_id that we manually run on the same physical devices.  Multipathd
> >>> itself was also in D state.  The only way to restore the whole thing was to
> >>> reset the server HBA
> >>> connected to FABRIC2, after 2 hours of investigation  No kind of scsi log,
> >>> or whatever did appear during the outage duration
> >>> (~2 hours) despite the fact that the scsi timeouts set on the physical
> >>> devices is 60s, that the HBA's timeout is 14s.  The
> >>> /sys/block/sdX/device/state were showing running state despite the
> >>> fact that the devices (well half of them) were actually inaccessible.
> >>>  What leads me to :  1) assumption: it looks the lpfc driver following this
> >>> SAN event goes in
> >>> a black hole mode not returning any io error or whatever to the scsi
> >>> upper layer  2) question: how come the scsi timers don't trigger and
> >>> declare the
> >>> device faulty (the answer may be in the above assumption).  Any idea or
> >>> tip on what could cause this, some FC SCN message not well
> >>> handled or whatever ?
> >>>
> >>> Regards
> >>>
> >>> Brem
> >>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>       
> >
> >   
> plain text document attachment (ChangeLog-8.2.0.33-to-8.2.0.66.txt)
> Changes from 20100126 to 20100205
> 
> 	* Changed version number to 8.2.0.66
> 	* Add FCF failover support
> 	* Add support for new SLI features
> 	* Added init_vpi mailbox command before re-registering VPI
> 
> Changes from 20100111 to 20100126
> 
> 	* Changed version number to 8.2.0.65
> 	* Add support for PCI BAR region 0 if BAR0 is a 64 bit register
> 	* Submit abort WQE to same work queue as the command WQE
> 	* Do not check class specific parameters for FLOGI (CR 97788)
> 	* Clean up ELS commands when unregistering unused ELS commands (CR
> 	  97048)
> 
> Changes from 20091218 to 20100111
> 
> 	* Changed version number to 8.2.0.64
> 	* Add QOS Link Speed info so user can see it (CR 96665)
> 	* Fix sli4 released aborted els cmd's xri (SGL) before HBA's abort
> 	  XRI event (CR 97288)
> 	* Support for Nport ID change after Clear Virtual Link (CR 97188)
> 
> Changes from 20091215 to 20091218
> 
> 	* Changed version number to 8.2.0.63
> 	* Fixed an issue where PowerPath did not work with OneConnect
> 	  CNA on SLES 10 Sp2 (CR 96996)
> 	* Fix Dead FCF not triggering discovery of other FCF (CR 97048
> 	  97049)
> 	* Fix vport->fc_flag set outside of lock caused I/O failure
> 	  during pci-func reset (CR 96975)
> 	* Fix driver tries to process failed read fcf record
> 	* Fixed fc header seq_count checks (CR 97010)
> 
> Changes from 20091208 to 20091215
> 
> 	* Changed version number to 8.2.0.62
> 	* Fixed hbq buff only for sli4
> 	* Fixed hbq buff adds to receive queue
> 	* Fix multi-frame sequence response frames go to wrong DID (CR
> 	  96915)
> 	* Fixed adapter reset and offline/online stress test failing with
> 	  I/O errors (CR 92904)
> 
> Changes from 20091125 to 20091208
> 
> 	* Changed version number to 8.2.0.61
> 	* Fix vport fails to register VPI after devloss timeout (CR 96740)
> 	* Fix bug with driver crashing during unload and sli4 aborting a ct
> 	  cmd (CR 96598)
> 	* Blocked all SCSI I/O requests from midlayer until target
> 	  rediscovery during EEH (CR 95889)
> 	* Made OneConnect UCNA set up and use single FCP EQ only under INTx
> 	  interrupt mode (CR 96645)
> 
> Changes from 20091124 to 20091125
> 
> 	* Changed version number to 8.2.0.60
> 	* Fix vport not logging out when being deleted (CR 96339)
> 
> Changes from 20091113 to 20091124
> 
> 	* Changed version number to 8.2.0.59
> 	* Fixed in-band remote firmware download (CR 96090)
> 	* Fix bug with mbox sysfs attribute smaller than the mailbox
> 	  extension size (CR 89016)
> 	* Phase out use of ONLINE registers
> 	* Made ABTS WQE go to the same WQ as the WQE to be aborted (CR
> 	  96110)
> 	* Add new READ_FCF_RECORD failure code
> 	* Remove Raywire PCI Device IDs permanently
> 
> Changes from 20091104 to 20091113
> 
> 	* Changed version number to 8.2.0.58
> 	* Fixed panic when unmapping luns (CR 94833)
> 	* Fix hbq pointer corruption (CR 95313)
> 	* Fix crash driver when fcauthd is started (CR 95584)
> 	* Fixed Dead FCoE port after creating vports (CR 95449)
> 	* Added handling of ELS request for Reinstate Recovery Qualifier (RRQ)
> 
> Changes from 20091021 to 20091104
> 
> 	* Changed version number to 8.2.0.57
> 	* Fixed: panic during pci-hot-plug testing (CR 95246)
> 	* Fix reg_vfi and reg_vpi routines to use little endian wwn
> 	* Change default Tomcat driver identification string to include
> 	  model number
> 	* Change lpfc_use_msi parameter to default to disable MSI and use INTx
> 	  mode
> 	* Migrate LUN queue depth ramp up code to scsi mid-layer
> 	* Fix vport keep-alive does not contain the correct WWN
> 	* Fix for lost MSI interrupt (CR 95404)
> 	* Ported the fix on reporting of max_vpi to uppper layer
> 	* Added PCI read after EQarm doorbell PCI write in INTx mode to
> 	  flush PCI pipeline
> 	* Removed trailing whitespaces to code line in quiescence of format
> 	  checker
> 	* Fix crash due to list corruption while unloading driver (CR
> 	  94889)
> 	* Fixed: lpfc_unreg_vfi failure after devloss timeout. Fixed RPI
> 	  bit leak (CR 94542)
> 
> Changes from 20091012 to 20091021
> 
> 	* Changed version number to 8.2.0.56
> 	* Added PCI ID for LPSe12002-ML1-E EmulexSecure Fibre Channel Adapter.
> 	* Fixed locking issue
> 	* Fix Zeroed frame on wire after FLOGI (CR 94950)
> 	* Fix Vport does not rediscover after FCF goes away
> 	* Fix memory leak found in lpfc_sli4_read_rev
> 	* Fix CVL received on Port 1 not processed by driver
> 	* Fixed the call from lpfc_new_scsi_buf_s3 to use
> 	  lpfc_release_scsi_buf_s3
> 	* Fixed total_scsi_bufs counting
> 	* Stop and abort all I/Os on HBA for AER uncorrectable non-fatal
> 	  error handling
> 
> Changes from 20091007 to 20091012
> 
> 	* Changed version number to 8.2.0.55
> 	* Made AER sysfs entry point return "Operation not permitted" to
> 	  OneConnect HBAs
> 	* Add support for Advanced Error Reporting (AER) feature support for SLI3 PCIe HBA
> 	* Fixed AER support is turned off by default (CR 94332)
> 	* Made driver with AER support backward compatible to distribution kernels
> 	  that do not support AER.
> 
> Changes from 20090923 to 20091007
> 
> 	* Changed version number to 8.2.0.54
> 	* Fix send sequence logic to handle multi SGL IOCBs
> 	* Fixed handling of unsolicited CT exchange initiator receiving CT exchange
> 	  ABTS
> 	* Fixed ELS_ID bits added to ELS WQE FIP frames
> 	* Fixed handling of unsolicited CT exchange sequence abort (uppper-level
> 	  driver part)
> 	* Fixed handling of unsolicited CT exchange sequence abort (lower level
> 	  driver part)
> 
> Changes from 20090909 to 20090923
> 
> 	* Changed version number to 8.2.0.53
> 	* Fixed discovery failure during quick link bounce
> 	* Add support for Clear Virtual Link
> 	* Fixed Check for aborted els command
> 	* Fix bug with missing new line characters in log messages (CR
> 	  94092)
> 	* Fix bug with probe_one routines not putting the Scsi_Host back
> 	  upon error (CR 94088)
> 	* Clear retry count in the delayed ELS handler
> 	* Check the rsplen in lpfc_handle_fcp_err function before using
> 	  rsplen
> 	* Removed the use of the locally defined FC transport layer related
> 	  macros
> 
> Changes from 20090826 to 20090909
> 
> 	* Changed version number to 8.2.0.52
> 	* Fix failed to allocate XRI message is not a critical failure
> 	* Removed an unused local variable
> 	* Update and fix formatting in some log messages
> 	* Add 0x0714 OCeXXXXX (TigerShark BE3) PCI ID
> 	* Optimized performance to slow-path handling of els
> 	  responses
> 	* Add code to cleanup orphaned unsolicited receive sequences
> 	* Fixed LPFC driver leaking irq vector when recovering from
> 	  uncorrectable AER (CR 92753)
> 	* Fixed buffer leak with loopback testing (CR 85563)
> 	* Fix memory leak with els echo command (CR 93535)
> 
> Changes from 20090814 to 20090826
> 
> 	* Changed version number to 8.2.0.51
> 	* Fixed devloss timeout when multiple initiators are in same zone
> 	  (CR 93255)
> 	* Fixed crash while processing unsolicited FC frames
> 	* Fixed VPI base not used when unregistering VPI on port 1
> 	* Fixed UNREG_VPI mailbox command to unreg the correct VPI
> 	* Fixed UNREG_VPI failure on extended link pull
> 	* Fixed IOCB leak in unsolicited sequence handling
> 	* Fixed a memory corruption during GID_FT IO prep
> 
> Changes from 20090729 to 20090814
> 
> 	* Changed version number to 8.2.0.50
> 	* Don't dereference NULL phba when kzalloc fails in lpfc_hba_alloc
> 	* Added support for read_rev mbox bits indicating FIP mode of HBA
> 	* Fix illegal frame error from firmware
> 	* Add external support flag to SLES 10 build
> 	* Added '\n' at the end of an error message (CR 88599)
> 	* Fix out of order ELS commands (CR 92341)
> 	* Fixed discovery issues found during VLAN testing
> 	* Error out requests to set board_mode to warm restart via sysfs on
> 	  SLI4 HBAs
> 
> Changes from 20090702 to 20090729
> 
> 	* Changed version number to 8.2.0.49
> 	* Fixed UE after vport create with high target count (CR 92270)
> 	* Fixed mask size for CT field in WQE
> 	* Fixed potential dereference of mailbox structure after free
> 	* Fix error when trying to load driver with iSCSI firmware on FCoE
> 	  HBA
> 	* Fix failure case when FCoE firmware is not present
> 	* Fix driver crash when creating vport with large number of targets
> 	  on SLI4 (CR 91447)
> 	* Fixed NPIV message being logged when it is not supported by the
> 	  adapter (CR 86273)
> 	* Fixed FCoE event tag passed in resume_rpi
> 	* Fixed panic during HBA reset
> 	* Fixed FCoE Parameter parsing in region 23
> 	* Fixed crash when "error" is echoed to board_mode sysfs parameter
> 	* Fixed Panic/hang when using polling mode for FCP commands
> 	  (CR 91684)
> 	* Remove spaces before newlines in log messages
> 	* Fix typos s/paramter/parameter/ and s/excute/execute/ in comments
> 	* Fix terminology inconsistency of dir name to mount debugfs in
> 	  comments
> 	* Fixed persistent post state to use config region 23 (CR 91320)
> 	* Fixed unsolicited CT commands crashing kernel
> 	* Fixed panic in menlo sysfs handler
> 	* Start ELS timer during SLI4 device initialization
> 	* Made FCP fast-path default event queue number match work queue
> 	  number for SLI4
> 	* Fix ctx_idx increment and rollover in receive unsolicited CT path
> 	* Fixed race condition when there are FCoE events during FCF table
> 	  read
> 
> Changes from 20090630 to 20090702
> 
> 	* Changed version number to 8.2.0.48
> 	* Fixed use of free_iocbq before NULL check in lpfc_prep_seq()
> 	* Wait for HBA POST completion before checking Online and UE registers
> 	* Remove cast when using pci_read_config_dword() to access
> 	  LPFC_SLIREV_CONF_WORD
> 	* Fixed unsolicited CT commands crashing kernel
> 	* Fixed static vport creation on SLI4 HBAs
> 	* Fixed vport create not to send INIT_VPI before REG_VFI
> 	* Restore behavior of lpfc_device_reset_handler to issue target
> 	  reset (CR 91267)
> 	* Remove duplicated SCSI netlink #defines from lpfc_auth_access.h
> 
> Changes from 20090618 to 20090623
> 
> 	* Changed version number to 8.2.0.47
> 	* Fixed unsolicited CT commands not being responded to
> 	* Fixed send management command length
> 	* Fixed driver unable to discover targets with DHCHAP enabled
> 	  (CR 91073)
> 	* Do not issue mailbox command when LPFC_HBA_ERROR with MBX_POLL
> 	  mode
> 	* Fixed accumulated total length not being filled in on SLI4
> 	  unsolicited IOCBs
> 	* Fixed FCoE parameters in region 23 not being read correctly
> 	* Fixed SLI3 in-band remote management (CR 91042)
> 
> Changes from 20090610 to 20090618
> 
> 	* Changed version number to 8.2.0.46
> 	* Remove always true conditional in lpfc_sli_read_serdes_param()
> 	* Update resume_rpi mailbox data structure to match spec
> 	* Rework/cleanup EH entry points to be consistent with upstream
> 	  implementation
> 	* Fixed lpfcdfc_host leak when lpfc_pci_remove_one_s4 called or
> 	  init error occurs
> 	* Use PCI config space register to determine SLI rev of HBA
> 	* Fixed crash when sending CT commands from libdfc
> 	* Fixed mailbox timeout during HBA reset
> 	* Fixed SLI4 HBAs not accessible from /dev/lpfcdfc
> 	* Show persistent link down state in link_state sysfs attribute
> 	* Fix for firmware dump failure (CR 90533)
> 
> Changes from 20090529 to 20090610
> 
> 	* Changed version number to 8.2.0.45
> 	* Rewrite lpfc_sli4_scmd_to_wqidx_distr() to handle counter
> 	  rollover cleanly
> 	* Fix switch name not used in the FCF record for FCoE HBAs
> 	* Enabled SLI4 HBA UE error polling error-condition action code
> 	* Fix vports unable to be created on port2 of an SLI4 HBA
> 	  (CR 90670)
> 	* Implemented persistent port disable functionality
> 	* Fix crash when accessing ctlregs from sysfs for SLI4 HBAs
> 	* Fix SLI4 firmware version not being saved or displayed correctly
> 	* Fix WQE structure to handle 16 bit CQID
> 	* Fixed SID for FDISC
> 	* Fixed handling of LOGO from Fabric port
> 	* Fixed uninitialized memory use
> 	* Fixed a memory leak in lpfc_wq_create()
> 	* Added code to free RPI bit map while unloading driver
> 
> Changes from 20090515 to 20090529
> 
> 	* Changed version number to 8.2.0.44
> 	* Fixed post header template mailbox command timing out (CR 90481)
> 	* Fixed consecutive link up events causing skipped link down
> 	  processing
> 	* Fixed a target mode discovery bug (CR 89882)
> 	* Removed unused jump table entries
> 	* Fixed a memory leak in lpfc_sli4_read_fcoe_params()
> 	* Added stricter checks for FCF addressing mode
> 	* Increased default WQE count to 256
> 	* Updated FDISC context to VPI
> 	* Fixed crash/hang when doing target or LUN resets
> 	* Fixed immediate SCSI command for LUN reset translation to WQE
> 	* Extended mailbox utility to allow MBX_POLL command in-between
> 	  async MBQ commands
> 	* Use in-kernel PCI functions on RHEL 5.4 where they are provided
> 	  by the kernel
> 	* Removed FCoE PCI device ID 0705
> 	* Fixed re-taking the same spin lock while already holding that
> 	  lock in lpfc_sli_eratt_read()
> 
> Changes from 20090508 to 20090515
> 
> 	* Changed version number to 8.2.0.43_ts2
> 	* Added code to send only FLOGI, FDISC and LOGO to Fabric
> 	  controller as FIP
> 	* Fixed a typo on adding vpi base
> 	* Fix GID_FT timeout
> 	* Remove pseudo SLI3 registers and only access SLI2/3 registers on
> 	  SLI2/3 HBAs
> 	* Replace DMA_(64|32)BIT_MASK macro with DMA_BIT_MASK(64|32)
> 	* Refactor nested if statements to avoid assignment within
> 	  conditional
> 	* Fixed default work queue size
> 	* Set the ct field of FDISC to 3
> 	* Finish removal of pseudo SLI3 registers
> 	* Fixed over allocation of SCSI bufs
> 	* Force vport to send LOGO to fabric controller when deleting vport
> 	* Fixes for FIP discovery
> 
> Changes from 20090429 to 20090508
> 
> 	* Changed version number to 8.2.0.43_ts1
> 	* Add missed spin_unlock in error path in lpfc_sli4_sp_handle_rcqe()
> 	* Fix for slow discovery
> 	* Fixed lpfc_sli4_iocb2wqe elsreq64 translation of CT fields
> 	* Fix first remote port does not UNREG_RPI
> 	* Fix REG_VFI failing after link reset
> 	* Fixed device spurious INT causing disabled IRQ due to unhandled
> 	  interrupts
> 	* Fix npiv_info displays "NPIV Physical" for SLI2 HBAs
> 	* For RHEL 5, use fc_fs.h file from kernel tree
> 	* Push hbalock lock/unlock down into lpfc_sli_sp_handle_rspiocb()
> 	* Moved heartbeat mailbox command timer start after queue setup
> 	* Fixed lpfc_sli_post_sgl_block page pairs
> 	* Made both WQ and EQ module configurable for FCP multi-queue
> 	  support
> 	* Prevent SLI4 from issuing REG_RPI for the fabric port
> 	* Make several calls static and remove unused lpfc_sli_get_sglq
> 	* Remove unneeded and reversed locking around call to
> 	  lpfc_rampdown_queue_depth
> 	* Remove unnecessary pci reads that impact performance
> 	* Prevent error message when add_fcf mbox fail due to fcf already
> 	  present
> 	* Removed FCP default CQ for consume WQE release from slow-path
> 	  handler
> 	* Implemented FCP fast-path multiple Work Queue support
> 	* Fix VPI and VFI base to work on port 2
> 	* Fixed selection of address mode
> 	* Removed unneeded SGL_ALIGN macros
> 	* Fix missing case in sysfs mailbox read
> 
> Changes from 20090424 to 20090429
> 
> 	* Changed version number to 8.2.0.43
> 	* Hook up VPD parsing for SLI4
> 	* Implemented module configurable FCP WQ interrupt coalescing
> 	  setup
> 	* Added code to read config region 23 for FCoE parameters
> 	* Removed unreachable code segment in lpfc_sli4_enable_msix
> 
> Changes from 20090420 to 20090424
> 
> 	* Changed version number to 8.2.0.42_ts1
> 	* Added code to allow SLI4 mailbox commands from libdfc
> 	* Implemented block SCSI SGL list repost after HBA reset
> 	* Made the phba->sli_rev for SLI4 flag set early in the driver
> 	  load
> 	* Fixed SLI4 sysfs rpi/vpi/xri parameters returned "Unknown"
> 	* Changed SLI4/SLI3 specific routine names to follow naming
> 	  convention
> 	* Fix ue 0x40000 (CR 89563)
> 	* Changes to use second SGL page for scsi DMA bufs
> 	* Fixed a missing return under PCI bus error condition in deferred-
> 	  eratt handling
> 
> Changes from 20090401 to 20090420
> 
> 	* Changed version number to 8.2.0.42
> 	* Added support for OneConnect UCNA
> 	* Set vport state to failed state after discovery failed due to
> 	  lack of VPIs
> 	* Added code to handle change in max_vpi after a reset
> 
> Changes from 20090309 to 20090401
> 
> 	* Changed version number to 8.2.0.41
> 	* Added lpfc_exclude_hba module parameter to exclude HBAs from
> 	  attaching
> 	* Fixed a discovery bug in lpfc_setup_disc_node (CR 88791)
> 	* Fixes of EEH support on both PPC P5 and P6 systems
> 	* Fixed a driver null pointer dereference in
> 	  lpfc_sli_process_sol_iocb (CR 88600)
> 
> Changes from 20090203 to 20090309
> 
> 	* Changed version number to 8.2.0.40
> 	* Take NULL terminator into account when calculating available
> 	  buffer space
> 	* Fix to support virtualized FC switch (CR 84900 85126 86016)
> 	* Added polling for error attention interrupt
> 	* Fixed memory leak in vport create + delete loop (CR 88105)
> 	* Added code to print all 16 words of unrecognized ASYNC events
> 	* Added LP2105 HBA model description
> 
> Changes from 20090120 to 20090203
> 
> 	* Changed version number to 8.2.0.39
> 	* Added lpfc_enable_hba_heartbeat and lpfc_enable_hba_reset
> 	  parameters to sysfs tree
> 	* Added sysfs interface to update speed and topology parameter
> 	  without link bounce (CR 87013)
> 	* Fixed loopback test failure (CR 87414)
> 
> Changes from 20090106 to 20090120
> 
> 	* Changed version number to 8.2.0.38
> 	* Fixed bug with sysfs fc_host WWNs not being updated after changing
> 	  the WWNs (CR 87390)
> 	* Fixed a kernel panic while trying to delete authentication timer
> 	  (CR 87144)
> 	* Increased HBQ buffers to support 40KB SSC sequences (CR 86564)
> 
> Changes from 20081223 to 20090106
> 
> 	* Changed version number to 8.2.0.37
> 	* Removed de-reference of scsi device after scsi_done is called (CR
> 	  87269)
> 	* Implemented host memory based HGP pointers (CR 87327)
> 
> Changes from 20081222 to 20081223
> 
> 	* Changed version number to 8.2.0.36
> 	* Fixed system panic due to ndlp indirect reference to phba through
> 	  vport (CR 86370)
> 	* Fixed a panic in mailbox timeout handler (CR 85228)
> 	* Fix bidirectional authentication failure (CR 86496)
> 
> Changes from 20081007 to 20081120
> 
> 	* Changed version number to 8.2.0.35
> 	* Fix firmware dump on FCoE adapters
> 	* Fixed wrong number of bytes copied reported to the app (CR 85743)
> 	* Fixed locking issue
> 	* Fixed warning: spinlock being held when dma_free_coherent is
> 	  called.
> 	* Fixed slow vport deletes
> 	* Changed mdelay to msleep in the ioctl path (CR 85606)
> 	* Fixed a discovery issue (CR 85714)
> 	* Fix allocation of HBQs should not be done in interrupt context
> 	  (CR 84717)
> 	* Fix memory leaks in netlink send code
> 	* Fix bug producing incorrect latency values (CR 85285)
> 	* Fix crash when collecting latency data (CR 85275)
> 	* Fixed false overrun failure for menlo commands that are less than
> 	  the command header size (CR 85168)
> 	* Fix memory leak with dump mailbox completion
> 	* Fix RSCN address format not handled properly (CR 82252)
> 	* Fixed time out handling in the worker thread (CR 84540)
> 
> Changes from 20081001 to 20081007
> 
> 	* Changed version number to 8.2.0.34
> 	* Added code to get option ROM version from HBA
> 	* Added FC_REG_VPORTRSCN_EVENT
> 	* Fixed statistical data collection for virtual ports
> 	* Fixed port busy events
> 	* Added a vendor unique RSCN event to send entire payload to
> 	  management application
> 	* Added data structures required for new events
> 	* Added code for supporting sleeping beauty events
> 	* Updated latency data collection
> 	* Added sysfs file to collect driver statistical data
> 
