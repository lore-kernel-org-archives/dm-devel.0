From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: default_prio_callout in multipath-tools-0.4.5-pre2
Date: Tue, 03 May 2005 17:26:24 -0400 (EDT)
Message-ID: <26483.5706017495$1115155274@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

In multipath.conf of multipath-tools-0.4.5-pre2, "/bin/true" is set
as default_prio_callout, but I think "none" is better as default.

"/bin/true" assigns a priority value of "0" and "none" assigns
that of "1", but the results are same according to the flat priority
assignment.
And "none" is more efficient, since "multipath" command doesn't
call execute_program() which does fork() and exec().

Additionally, dependent commands can be reduced by using "none".
It is helpful for / on multipath, since commands which need to be
included in initramfs can be reduced when the default setting is used.

Any comments?

Thanks,
Ky (Kiyoshi Ueda)
