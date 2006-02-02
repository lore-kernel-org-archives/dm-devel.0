From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Oops with snapshots in 2.6.16-rc1-mm4
Date: Thu, 2 Feb 2006 12:33:13 +0100
Message-ID: <20060202113313.GA23651@redhat.com>
References: <1138874453.10636.6.camel@leto.intern.saout.de>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1138874453.10636.6.camel@leto.intern.saout.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Can't see any precaution preventing a snapshot from being destructed
while kcopyd is still doing io on a job.

We should better get some flesh into:

/*
 * Cancels a kcopyd job, eg. someone might be deactivating a
 * mirror.
 */
int kcopyd_cancel(struct kcopyd_job *job, int block)
{
        /* FIXME: finish */
        return -1;
}

and call it appropriately from the snapshot destructor
(unregister_snapshot() looks like the place for it).

Heinz


On Thu, Feb 02, 2006 at 11:00:53AM +0100, Christophe Saout wrote:
> Hello,
> 
> I managed to get this Oops when lvremove'ing a snapshot. This is done by
> a script so it doesn't wait while executing the commands and it looks
> like some sort of race condition with BIOs still being processed by
> kcopyd when kcopy_client_destroy is called.
> 
> I would love to dig into this but I'm still very busy and don't have
> time to dig into this.
> 
> Feb  2 00:31:11 websrv2 ----------- [cut here ] --------- [please bite here ] ---------
> Feb  2 00:31:11 websrv2 Kernel BUG at drivers/md/kcopyd.c:154
> Feb  2 00:31:11 websrv2 invalid opcode: 0000 [1] PREEMPT 
> Feb  2 00:31:11 websrv2 last sysfs file: /block/ram0/dev
> Feb  2 00:31:11 websrv2 CPU 0 
> Feb  2 00:31:11 websrv2 Modules linked in: ipt_LOG ip6table_filter ip6_tables twofish serpent blowfish sha256 aes ipt_owner xt_mark xt_state ipt_REJECT xt_tcpudp ipt_multiport iptable_filter iptable_mangle ip_tables x_tables ext3 jbd reiser4 ip_conntrack_irc ip_conntrack_ftp ip_conntrack via_rhine 8139too crc32 raid5 xor
> Feb  2 00:31:11 websrv2 Pid: 21930, comm: lvremove Not tainted 2.6.16-rc1-cs1 #1
> Feb  2 00:31:11 websrv2 RIP: 0010:[<ffffffff8035a86c>] <ffffffff8035a86c>{client_free_pages+12}
> Feb  2 00:31:11 websrv2 RSP: 0018:ffff81005daebcc8  EFLAGS: 00010287
> Feb  2 00:31:11 websrv2 RAX: 00000000000000de RBX: ffff810023856820 RCX: ffffffff8053f000
> Feb  2 00:31:11 websrv2 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff810023856820
> Feb  2 00:31:11 websrv2 RBP: ffffc20000883040 R08: ffff81007cc19d00 R09: 0000000000000001
> Feb  2 00:31:11 websrv2 R10: 0000000000000001 R11: ffffffff80178a90 R12: 0000000000000000
> Feb  2 00:31:11 websrv2 R13: 0000000000000004 R14: ffff81005daebd68 R15: ffffffff80359ae0
> Feb  2 00:31:11 websrv2 FS:  00002ae3e21faa70(0000) GS:ffffffff80667000(0000) knlGS:00000000f7fbd6b0
> Feb  2 00:31:11 websrv2 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Feb  2 00:31:11 websrv2 CR2: 00007fffc88ad3b0 CR3: 000000002933f000 CR4: 00000000000006e0
> Feb  2 00:31:11 websrv2 Process lvremove (pid: 21930, threadinfo ffff81005daea000, task ffff81004989a850)
> Feb  2 00:31:11 websrv2 Stack: ffff810023856820 ffffffff8035a994 ffff81004b6590c0 ffffffff8035c420 
> Feb  2 00:31:11 websrv2 ffff81004c8a8800 ffffc20000883040 ffff81004c8a8800 ffffffff8035684b 
> Feb  2 00:31:11 websrv2 ffff81004c8a8800 ffff81005ced45c0 
> Feb  2 00:31:11 websrv2 Call Trace: <ffffffff8035a994>{kcopyd_client_destroy+20}
> Feb  2 00:31:11 websrv2 <ffffffff8035c420>{snapshot_dtr+304} <ffffffff8035684b>{dm_table_put+107}
> Feb  2 00:31:11 websrv2 <ffffffff80359310>{__hash_remove+192} <ffffffff80359b38>{dev_remove+88}
> Feb  2 00:31:11 websrv2 <ffffffff803598e3>{ctl_ioctl+579} <ffffffff80424795>{schedule+229}
> Feb  2 00:31:11 websrv2 <ffffffff80184089>{do_ioctl+105} <ffffffff80184362>{vfs_ioctl+674}
> Feb  2 00:31:11 websrv2 <ffffffff801843e9>{sys_ioctl+73} <ffffffff8010acba>{system_call+126}
> Feb  2 00:31:11 websrv2 
> Feb  2 00:31:11 websrv2 Code: 0f 0b 68 ca 98 47 80 c2 9a 00 48 8b 7b 10 e8 a1 ff ff ff 48 
> Feb  2 00:31:11 websrv2 RIP <ffffffff8035a86c>{client_free_pages+12} RSP <ffff81005daebcc8>
> Feb  2 00:31:11 websrv2 <1>Unable to handle kernel NULL pointer dereference at 0000000000000040 RIP: 
> Feb  2 00:31:11 websrv2 <ffffffff80175579>{bio_add_page+25}
> Feb  2 00:31:11 websrv2 PGD 0 
> Feb  2 00:31:11 websrv2 Oops: 0000 [2] PREEMPT 
> Feb  2 00:31:11 websrv2 last sysfs file: /block/ram0/dev
> Feb  2 00:31:11 websrv2 CPU 0 
> Feb  2 00:31:11 websrv2 Modules linked in: ipt_LOG ip6table_filter ip6_tables twofish serpent blowfish sha256 aes ipt_owner xt_mark xt_state ipt_REJECT xt_tcpudp ipt_multiport iptable_filter iptable_mangle ip_tables x_tables ext3 jbd reiser4 ip_conntrack_irc ip_conntrack_ftp ip_conntrack via_rhine 8139too crc32 raid5 xor
> Feb  2 00:31:11 websrv2 Pid: 8002, comm: kcopyd Not tainted 2.6.16-rc1-cs1 #1
> Feb  2 00:31:11 websrv2 RIP: 0010:[<ffffffff80175579>] <ffffffff80175579>{bio_add_page+25}
> Feb  2 00:31:11 websrv2 RSP: 0018:ffff81003f639c90  EFLAGS: 00010287
> Feb  2 00:31:11 websrv2 RAX: 0000000000000000 RBX: 0000000000000010 RCX: 0000000000001000
> Feb  2 00:31:11 websrv2 RDX: ffff810001c9a548 RSI: ffff81006dd36840 RDI: ffff81006dd36840
> Feb  2 00:31:11 websrv2 RBP: ffff81006dd36840 R08: 0000000000000000 R09: ffff81003f0756c0
> Feb  2 00:31:11 websrv2 R10: ffff81006dd36840 R11: 0000000000000001 R12: ffff81003f639d68
> Feb  2 00:31:11 websrv2 R13: ffff81005c82a500 R14: ffff81005c9b8a80 R15: ffff81003f639ce0
> Feb  2 00:31:11 websrv2 FS:  00002ae3e21faa70(0000) GS:ffffffff80667000(0000) knlGS:00000000f7fbd6b0
> Feb  2 00:31:11 websrv2 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Feb  2 00:31:11 websrv2 CR2: 0000000000000040 CR3: 000000002933f000 CR4: 00000000000006e0
> Feb  2 00:31:11 websrv2 Process kcopyd (pid: 8002, threadinfo ffff81003f638000, task ffff810048fa51c0)
> Feb  2 00:31:11 websrv2 Stack: ffffffff8035a13c 0000000000000010 0000000100000001 0000000000000000 
> Feb  2 00:31:11 websrv2 ffffffff80359df0 ffffffff80359e20 0000000000000008 ffff81003ca43ea0 
> Feb  2 00:31:11 websrv2 0000000000000100 0000000000001000 
> Feb  2 00:31:11 websrv2 Call Trace: <ffffffff8035a13c>{dispatch_io+316} <ffffffff80359df0>{list_get_page+0}
> Feb  2 00:31:11 websrv2 <ffffffff80359e20>{list_next_page+0} <ffffffff8035b520>{complete_io+0}
> Feb  2 00:31:11 websrv2 <ffffffff8035a284>{async_io+196} <ffffffff8035b520>{complete_io+0}
> Feb  2 00:31:11 websrv2 <ffffffff8035a400>{dm_io_async+80} <ffffffff80359df0>{list_get_page+0}
> Feb  2 00:31:11 websrv2 <ffffffff80359e20>{list_next_page+0} <ffffffff8035ad80>{run_io_job+0}
> Feb  2 00:31:11 websrv2 <ffffffff8035ab80>{do_work+0} <ffffffff8035addc>{run_io_job+92}
> Feb  2 00:31:11 websrv2 <ffffffff8035aa1e>{process_jobs+30} <ffffffff8013b73b>{run_workqueue+219}
> Feb  2 00:31:11 websrv2 <ffffffff8013f0f0>{keventd_create_kthread+0} <ffffffff8013bf31>{worker_thread+353}
> Feb  2 00:31:11 websrv2 <ffffffff80124ac0>{default_wake_function+0} <ffffffff8013bdd0>{worker_thread+0}
> Feb  2 00:31:11 websrv2 <ffffffff8013f23b>{kthread+219} <ffffffff8010b7d2>{child_rip+8}
> Feb  2 00:31:11 websrv2 <ffffffff8013f0f0>{keventd_create_kthread+0} <ffffffff8013f160>{kthread+0}
> Feb  2 00:31:11 websrv2 <ffffffff8010b7ca>{child_rip+0}
> Feb  2 00:31:11 websrv2 
> Feb  2 00:31:11 websrv2 Code: 48 8b 78 40 44 0f b7 8f 4c 02 00 00 e9 d6 fd ff ff 66 66 90 
> Feb  2 00:31:11 websrv2 RIP <ffffffff80175579>{bio_add_page+25} RSP <ffff81003f639c90>
> Feb  2 00:31:11 websrv2 CR2: 0000000000000040
> 



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
