From: Igor Druzhinin <igor.druzhinin@citrix.com>
Subject: Re: BUG: unable to handle kernel paging request
Date: Thu, 28 Sep 2017 20:45:08 +0100
Message-ID: <d072404e-dba4-dee7-b1d8-b55c569be51e@citrix.com>
References: <f5fcde71-f10d-7b38-6a66-bef9714e5c4c@citrix.com>
	<20170928175606.GA19419@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170928175606.GA19419@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 28/09/17 18:56, Mike Snitzer wrote:
> On Thu, Sep 28 2017 at 12:33pm -0400,
> Igor Druzhinin <igor.druzhinin@citrix.com> wrote:
> 
>> Hi Mike,
>>
>> I'm from XenServer engineering. We're currently using 4.4 stable kernel
>> (4.4.52 now) and intermittently seeing the following issue with dm-multipath
>> target during our storage certification test:
>>
>> [   2619.971820]    ERR: blk_update_request: I/O error, dev sdd, sector 39176
>> [   2619.971838]   WARN: device-mapper: multipath: Failing path 8:48.
>> [   2641.971739]    ERR:  connection158:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4295548436, last ping 4295549688, now 4295550940
>> [   2641.971786]   INFO:  connection158:0: detected conn error (1022)
>> [   2646.979770]   INFO:  session158: session recovery timed out after 5 secs
>> [   2646.979787]    ERR: sd 162:0:0:0: rejecting I/O to offline device
>> [   2646.979812]   INFO: sd 162:0:0:0: [sdc] killing request
>> [   2646.979841]   INFO: sd 162:0:0:0: [sdc] FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>> [   2646.979848]   INFO: sd 162:0:0:0: [sdc] CDB: Write(10) 2a 00 00 00 99 08 00 08 00 00
>> [   2646.979852]    ERR: blk_update_request: I/O error, dev sdc, sector 39176
>> [   2646.979873]   WARN: device-mapper: multipath: Failing path 8:32.
>> [   2647.095324]  ALERT: BUG: unable to handle kernel paging request at ffffc90040154048
>> [   2647.095354]  ALERT: IP: [<ffffffffa03cb52c>] dm_softirq_done+0xcc/0x220 [dm_mod]
>> [   2647.095377]   WARN: PGD 2ee66067 PUD 29093067 PMD 29094067 PTE 0
>> [   2647.095391]   WARN: Oops: 0000 [#1] SMP 
>> [   2647.095400]   WARN: Modules linked in: dm_service_time bnx2i(O) iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi arc4 md4 cifs bnx2fc(O) cnic(O) uio fcoe libfcoe libfc scsi_transport_fc openvswitch nf_defrag_ipv6 libcrc32c 8021q garp mrp stp llc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_tcpudp xt_multiport xt_conntrack nf_conntrack iptable_filter dm_multipath ipmi_devintf dcdbas ipmi_si ipmi_msghandler dm_mod sg coretemp i7core_edac edac_core hed lpc_ich tpm_tis tpm mfd_core shpchp nls_utf8 isofs nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc ip_tables x_tables autofs4 sd_mod sr_mod cdrom hid_generic usbhid hid ata_generic pata_acpi ata_piix libata bnx2(O) mptsas scsi_transport_sas mptscsih mptbase ehci_pci ehci_hcd ixgbe(O) vxlan ip6_udp_tunnel ud
 p_tunnel ptp pps_core scsi_dh_rdac
>> [   2647.095651]   WARN:  scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_mod ipv6
>> [   2647.095672]   WARN: CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           O    4.4.0+10 #1
>> [   2647.095693]   WARN: Hardware name: Dell Inc. PowerEdge R310/0P229K, BIOS 1.0.0 02/11/2010
>> [   2647.095717]   WARN: task: ffff88002919d040 ti: ffff8800291a8000 task.ti: ffff8800291a8000
>> [   2647.095737]   WARN: RIP: e030:[<ffffffffa03cb52c>]  [<ffffffffa03cb52c>] dm_softirq_done+0xcc/0x220 [dm_mod]
>> [   2647.095768]   WARN: RSP: e02b:ffff88002d643d48  EFLAGS: 00010082
>> [   2647.095781]   WARN: RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff88002d640000
>> [   2647.095797]   WARN: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90040154040
>> [   2647.095814]   WARN: RBP: ffff88002d643d70 R08: 000000000000001c R09: 000000000000001c
>> [   2647.095829]   WARN: R10: 0000000000000009 R11: 0000000000007ffe R12: ffff880013ee0c60
>> [   2647.095844]   WARN: R13: ffff880013ee0bf0 R14: 0000000000000000 R15: ffff8800053a3e58
>> [   2647.095866]   WARN: FS:  00007fc029a14900(0000) GS:ffff88002d640000(0000) knlGS:0000000000000000
>> [   2647.095887]   WARN: CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
>> [   2647.095900]   WARN: CR2: ffffc90040154048 CR3: 0000000026ed4000 CR4: 0000000000002660
>> [   2647.095916]   WARN: Stack:
>> [   2647.095925]   WARN:  ffff880013ee0a80 ffffe8ffffa04a00 0000000000000002 0000000000000000
>> [   2647.095949]   WARN:  ffff8800053a3e58 ffff88002d643d98 ffffffff812fb9d1 0000000000000000
>> [   2647.095973]   WARN:  ffff880013ee0bf0 ffff880013e3e600 ffff88002d643da8 ffffffff812fba0c
>> [   2647.095996]   WARN: Call Trace:
>> [   2647.096007]   WARN:  <IRQ> 
>> [   2647.096019]   WARN:  [<ffffffff812fb9d1>] __blk_mq_complete_request+0xc1/0xe0
>> [   2647.096041]   WARN:  [<ffffffff812fba0c>] blk_mq_complete_request+0x1c/0x20
>> [   2647.096062]   WARN:  [<ffffffffa03cb195>] dm_complete_request+0x45/0x50 [dm_mod]
>> [   2647.096082]   WARN:  [<ffffffffa03cb1da>] end_clone_request+0x3a/0x40 [dm_mod]
>> [   2647.096099]   WARN:  [<ffffffff812f29a9>] blk_finish_request+0x99/0xd0
>> [   2647.096126]   WARN:  [<ffffffffa005d9c3>] scsi_end_request+0x153/0x1a0 [scsi_mod]
>> [   2647.096157]   WARN:  [<ffffffffa00607f9>] scsi_io_completion+0x239/0x610 [scsi_mod]
>> [   2647.096188]   WARN:  [<ffffffffa0057f98>] scsi_finish_command+0x108/0x120 [scsi_mod]
>> [   2647.096226]   WARN:  [<ffffffffa005ff08>] scsi_softirq_done+0x128/0x140 [scsi_mod]
>> [   2647.096248]   WARN:  [<ffffffff812f9888>] blk_done_softirq+0x78/0x90
>> [   2647.096272]   WARN:  [<ffffffff810761e9>] __do_softirq+0x129/0x290
>> [   2647.096295]   WARN:  [<ffffffff81076522>] irq_exit+0x42/0x90
>> [   2647.096315]   WARN:  [<ffffffff813c64d5>] xen_evtchn_do_upcall+0x35/0x50
>> [   2647.096335]   WARN:  [<ffffffff815a4dae>] xen_do_hypervisor_callback+0x1e/0x40
>> [   2647.096351]   WARN:  <EOI> 
>> [   2647.096365]   WARN:  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>> [   2647.096393]   WARN:  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>> [   2647.096412]   WARN:  [<ffffffff8100c460>] ? xen_safe_halt+0x10/0x20
>> [   2647.096433]   WARN:  [<ffffffff81020d67>] ? default_idle+0x57/0xf0
>> [   2647.096454]   WARN:  [<ffffffff8102149f>] ? arch_cpu_idle+0xf/0x20
>> [   2647.096474]   WARN:  [<ffffffff810aadb2>] ? default_idle_call+0x32/0x40
>> [   2647.096495]   WARN:  [<ffffffff810ab00c>] ? cpu_startup_entry+0x1ec/0x330
>> [   2647.096517]   WARN:  [<ffffffff81013c18>] ? cpu_bringup_and_idle+0x18/0x20
>> [   2647.096531]   WARN: Code: ff ff e9 67 01 00 00 48 8b 43 40 41 8b 5d 40 4d 8b ac 24 60 01 00 00 48 c1 e8 17 49 8b 7d 08 48 83 f0 01 83 e0 01 48 85 ff 74 1f <48> 8b 57 08 84 c0 4c 8b 42 60 74 13 4d 85 c0 74 0e 89 da 49 8d 
>> [   2647.096640]  ALERT: RIP  [<ffffffffa03cb52c>] dm_softirq_done+0xcc/0x220 [dm_mod]
>> [   2647.096662]   WARN:  RSP <ffff88002d643d48>
>> [   2647.096673]   WARN: CR2: ffffc90040154048
>> [   2647.096993]   WARN: ---[ end trace 450fe22bd6f6d100 ]---
>> [   2647.100979]  EMERG: Kernel panic - not syncing: Fatal exception in interrupt
>>
>> This happens on multipath failover stress test. The issue is obviously
>> only present if multiqueue is enabled for DM. Preliminary analysis
>> revealed that it's some sort of a race condition - the request is
>> trying to access an already reallocated array of dm_target structures.
>>
>> As I don't have any extensive experience in debugging that sort of
>> problems in the block layer I'm stuck at this. It's complicated to
>> test a modern kernel in our environment so the question is:
>>
>> Is it some known problem? And if not what can we possibly do to finally
>> understand the root cause of it?
> 
> This was likely fixed with commit 61febef40bfe8ab68259d8545257686e8a0d91d1
> 

I doubt so. It says:
Fixes: eb8db831be80 ("dm: always defer request allocation to the owner of the request_queue")
which is not present in 4.4.

And the crash happens in the other code branch (clone completion):

static void dm_done(struct request *clone, int error, bool mapped)
{
	int r = error;
	struct dm_rq_target_io *tio = clone->end_io_data;
	dm_request_endio_fn rq_end_io = NULL;

	if (tio->ti) {
		rq_end_io = tio->ti->type->rq_end_io; <=== crash while dereferencing tio->ti

		if (mapped && rq_end_io)
			r = rq_end_io(tio->ti, clone, error, &tio->info);
	}

Igor
