From: Malahal Naineni <malahal@us.ibm.com>
Subject: [BUG] multipath-tools: uuid has become meaningless
Date: Mon, 19 Jul 2010 15:45:28 -0700
Message-ID: <20100719224528.GA23414@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi All,

	I have noticed that uuid reported my 'multipath -l' doesn't
really correspond to the paths it loaded. In fact, the machine has two
different storage subsystems, say EMC and IBM, and the 'multipath -l'
output looks like it reported EMC instead of IBM as vendor and vice
versa. Further debugging showed that the system is configured with
'user_friendly_names' in initrd.  Initrd actually configures all the
paths correctly using 'user_friendly_names' as intended, but the real
root's multipathd init script's invocation tried to match the names in
/var/lib/multipath/bindings file (this file has grown since the last
mkinitrd!).  Instead of just renaming, it actually re-loads with
different paths!

One easy way to reproduce the problem is to run multipath once, edit the
bindings file to swap couple entries (mpatha to mpathb and vice versa)
and then run multipath. The later run of multipath reloads mpatha with
mpathb's paths and vice versa, instead of just renaming. I know renaming
is hard here as they have to be unique when you rename!

Here is the code where the things happen:
libmultipath/configure.c: select_action(): This may reload if it finds
cmpp "by alias" as well as "by wwid".

Technically, this is not wrong! No I/O should be happening in the
original reported case when the device mapper tables are reloaded. It is
just that the uuid's loaded have become meaningless for user!
'multipath -l' has no point in reporting the uuid if it becomes useless!

My thoughts on fixing this:
1. Technically nothing wrong. Live with it and make sure that device
   mapper's uuid are meaningless for user and fix 'multipath -l' to
   not print uuid's.
2. Don't support user_friendly_names in initrd. Could be just documented
   or an option to multipath is added to ignore that feature and that
   option is used in initrd calls!
3. We could rename the devices instead of reload -- really fixing this!

Any comments on which way we should go and other possibilities?

Thanks, Malahal.
