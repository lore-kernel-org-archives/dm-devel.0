From: Hannes Reinecke <hare@suse.de>
Subject: Re: good dm-mpath test setup?
Date: Thu, 05 Jun 2014 14:14:17 +0200
Message-ID: <53905F19.2070401@suse.de>
References: <20140605115011.GA816@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010207030209070600040605"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140605115011.GA816@infradead.org>
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010207030209070600040605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx6-phx2.redhat.com id s55CEMQn026905

On 06/05/2014 01:50 PM, Christoph Hellwig wrote:
> I've been looking into support blk-mq/scsi-mq in dm-mpath, but I'm
> already running into issues with mainline.  I created a couple luns
> (without second path) using iet, and then using the iscsi initiator
> to access them.  But it seems like no I/O is possible through dm-mpath
> for this simple setup as the kpartx processes spawned by udev already
> hang.  Is dm-mpath (default config, no multipath.conf) support to work
> for a single path setup, or is this expected behavior?
>
Hmm. This shouldn't happen.

But be aware, that multipath doesn't play well together with systemd=20
currently.
I've done plenty of fixes to get it up and running for SLES12; once=20
they've stabilized I'll be sending them mainline.

But for a stable testbed I would recommend against systemd currently.

> Does anyone have a good default iet or maybe lio config for dm-mpath
> testing?
>
The easiest bit would be set set up lio in loopback mode, and map=20
two luns pointing to the same device.

I've attached a small script I'm using for a quick test here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------010207030209070600040605
Content-Type: application/x-shellscript;
 name="setup_loopback.sh"
Content-Disposition: attachment;
 filename="setup_loopback.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmltZz0vYWJ1aWxkL3RhcmdldC9kaXNrMS5pbWcKaGJhPWZpbGVpb18w
L2Rpc2sxCmxvb3A9L3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9sb29wYmFjawpjb3JlPS9z
eXMva2VybmVsL2NvbmZpZy90YXJnZXQvY29yZQpzZWNfdHBnPSJzZWNvbmRhcnlfdGdfcHRf
Z3AiCgppZiBbICEgLWYgJHtpbWd9IF0gOyB0aGVuCiAgICBbIC1kICR7aW1nJS8qfSBdIHx8
IG1rZGlyICR7aW1nJS8qfQogICAgcWVtdS1pbWcgY3JlYXRlIC1mIHJhdyAke2ltZ30gNEcK
ZmkKCmlmIFsgISAtZCAke2NvcmV9LyR7aGJhfSBdIDsgdGhlbgogICAgdGNtX25vZGUgLS1m
aWxlaW89JGhiYSAvYWJ1aWxkL3RhcmdldC9kaXNrMS5pbWcgNDI5NDk2NzI5NgpmaQpbIC1k
ICR7Y29yZX0vJHtoYmF9IF0gfHwgZXhpdCAxCmlmIFsgISAtZCAke2NvcmV9LyR7aGJhfS9h
bHVhLyR7c2VjX3RwZ30gXSA7IHRoZW4KICAgIHRjbV9ub2RlIC0tYWRkdGdwdGdwPSRoYmEg
c2Vjb25kYXJ5X3RnX3B0X2dwCmZpCgpmb3IgdCBpbiAke2xvb3B9L25hYS4qL3RwZ3RfKiA7
IGRvCiAgICBbIC1kICR7ZH0gXSB8fCBjb250aW51ZQogICAgdHBndD0ke3QjIyp0cGd0X30K
ICAgIGlmIFsgIiR0cGd0IiA9ICIwIiBdIDsgdGhlbgoJbmV4dXMwPTEKICAgIGZpCiAgICBp
ZiBbICIkdHBndCIgPSAiMSIgXSA7IHRoZW4KCW5leHVzMT0xCiAgICBmaQpkb25lCmlmIFsg
LXogIiRuZXh1czAiIF0gOyB0aGVuCiAgICB0Y21fbG9vcCAtLWNyZWF0ZW5leHVzPTAKZmkK
CmlmIFsgLXogIiRuZXh1czEiIF0gOyB0aGVuCiAgICB0Y21fbG9vcCAtLWNyZWF0ZW5leHVz
PTEKZmkKCm51bV9uYWE9MApmb3IgZCBpbiAke2xvb3B9L25hYS4qIDsgZG8KICAgIFsgLWQg
JHtkfSBdIHx8IGNvbnRpbnVlCiAgICBuYWE9JHtkIyMqL30KICAgICgoIG51bV9uYWErKyAp
KSB8fCB0cnVlCiAgICBmb3IgdCBpbiAke2R9L3RwZ3RfKiA7IGRvCglbIC1kICR7dH0gXSB8
fCBjb250aW51ZQoJaWYgWyAhIC1kICR7dH0vbHVuL2x1bl8wIF0gOyB0aGVuCgkgICAgdHBn
dD0ke3QjIyp0cGd0X30KCSAgICB0Y21fbG9vcCAtLWFkZGx1bj0kbmFhICR0cGd0IDAgJGhi
YSB8fCBleGl0IDEKCWZpCglpZiBbICR0cGd0ID0gIjEiIF0gOyB0aGVuCgkgICAgZWNobyBz
ZWNvbmRhcnlfdGdfcHRfZ3AgPiAke3R9L2x1bi9sdW5fMC9hbHVhX3RnX3B0X2dwCglmaQog
ICAgZG9uZQpkb25lCgp0Y21fbm9kZSAtLWxpc3R0Z3B0Z3BzPWZpbGVpb18wL2Rpc2sxCg==
--------------010207030209070600040605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------010207030209070600040605--
