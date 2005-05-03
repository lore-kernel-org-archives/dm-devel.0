From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Unable to use multipath with LVM2
Date: Tue, 3 May 2005 13:16:55 +0200
Message-ID: <20050503111655.GK1285@marowsky-bree.de>
References: <BFCF159FFD14F444B205968F32DBD5BB01700358@MAILEX01.rasgroup.ita.localnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BFCF159FFD14F444B205968F32DBD5BB01700358@MAILEX01.rasgroup.ita.localnet>
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

On 2005-04-30T09:29:21, Magni Fabrizio <Fabrizio.Magni@rasnet.it> wrote:

> Hello,
> I'm new to multipath and I'm having an hard time configuring the one
> shipped with my distribution. The version is "multipath v0.3.6".

It'd be helpful if you actually reported which distribution you're
talking about ;-)

But looking at your version, I guess you might be running SLES9. In
which case SP2 should help address your troubles:
http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html

Please try and get access to the beta via your support contact.

> If I insert aliases in multipath.conf and modify udev.rules I can see
> symbolick links wichi can be used in failover or multibus (tested) but
> they are not seen by the LVM2 (even modifying the filter in lvm.conf an=
d
> specifying "types").

With those changes LVM2 is supposed to recognize them. Not sure why it
doesn't for you.

> What devices should the LVM scan to use multipathed PVs?

Either the /dev/disk/by-*/ files, or /dev/dm-*; either will do. It's
just important that it only uses those paths and doesn't use the raw
disks (/dev/sdX).

This needs to be addressed to work out-of-the-box later, but for the
time being you'll need to adjust lvm.conf manually.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
