From: Busby <chaimvy@gmail.com>
Subject: Re: [PATCH v6 3/4] dm-replicator: ringbuffer replication
 log handler
Date: Mon, 18 Jul 2011 17:44:09 +0800
Message-ID: <CAJv3x-WhfDBLyTeWtuT0ozUyQv7en6pdACHagAFiWLHnhDOTaA@mail.gmail.com>
References: <1261151073-25962-1-git-send-email-heinzm@redhat.com>
	<1261151073-25962-2-git-send-email-heinzm@redhat.com>
	<1261151073-25962-3-git-send-email-heinzm@redhat.com>
	<1261151073-25962-4-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1261151073-25962-4-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

is there any bug in slink_fallbehind_update function?

I use the dm-repl module, while the oops came as:

localhost kernel: Oops: 0010 [#2] SMP
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel: last sysfs file: /sys/module/scsi_transport_iscsi/version
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel: Stack:
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  ffff88005f5019e0 0000000000000000 ffff8800574d58c0
0000000000000000
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  0000000000000000 ffff8800be3e3800 ffffffffa0320d50
0000000000000000
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel: Call Trace:
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffffa031ddb7>] ?
slink_fallbehind_update+0x1f7/0x30e [dm_repl_log_ringbuffer]
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffffa0320d50>] ? do_log+0xf07/0x12ab
[dm_repl_log_ringbuffer]
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffffa031c4aa>] ? data_endio+0x0/0x10
[dm_repl_log_ringbuffer]
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffffa031c4ba>] ? header_endio+0x0/0xd
[dm_repl_log_ringbuffer]
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8020c9ee>] ? apic_timer_interrupt+0xe/0x20
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8022e37c>] ? update_curr+0x6f/0xaa
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff80236661>] ? dequeue_task_fair+0x93/0x105
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff804aab5d>] ? thread_return+0x3d/0xb0
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffffa031fe49>] ? do_log+0x0/0x12ab
[dm_repl_log_ringbuffer]
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8024802c>] ? run_workqueue+0x7a/0x102
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8024894c>] ? worker_thread+0xd5/0xe0
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8024b2a6>] ? autoremove_wake_function+0x0/0x2e
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff80248877>] ? worker_thread+0x0/0xe0
Message from syslogd@ at Thu Jul 21 06:42:27 2011 ...
localhost kernel:  [<ffffffff8024b176>] ? kthread+0x47/0x75

it seems there is something wrong in this section:

list_for_each_entry(pos, L_SLINK_COPY_LIST(l),
				    lists.l[E_WRITE_OR_COPY]) {
			struct slink_copy_context *cc;

			list_for_each_entry(cc, E_COPY_CONTEXT_LIST(pos),
					    list) {
				if (cc->slink->ops->slink_number(cc->slink) ==
				    slink_nr) {
					ss->fb.head_jiffies = cc->start_jiffies;
					break;
				}
			}
		}



maybe "cc->slink->ops->slink_number(cc->slink)" return an err?
