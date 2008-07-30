From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: /dev/dm-? and /dev/mapper/
Date: Wed, 30 Jul 2008 08:44:11 +0200
Message-ID: <200807300844.11578.wilhelm.meier@fh-kl.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I don't know if this is the right place to ask ...

I use kernel 2.6.22 and debian etch.

If I create a vg and some volumes in it I get the

/dev/dm-?

and

/dev/mapper/<vg>-<lv>

devices nodes.

If I try to mount the filesystem via label, sometimes /dev/dm-? and 
sometimes /dev/mapper/<vg>-<lv> gets mounted.

That is the cause of some later errors in my setup.

The question is: how can I get rid of the dm-? (e.g. they should not 
be created at all) oder how do I the mount to stick to 
the /dev/mapper/... files?

TIA,
-- 
Wilhelm
