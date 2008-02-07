From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout issues
	withHPXP1024diskarray
Date: Thu, 7 Feb 2008 15:05:30 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F1AA@exchmail03.ncogroup.com>
References: <20080207195309.GA7566@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080207195309.GA7566@us.ibm.com>
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

The multipathd, on boot, seems to get some of the devices, but not all.
To keep the thread clean, can you look for my email dated January 31
with the subject "Multipath not rebuilding correctly on reboot"?  There
is a full description there with output files showing the state things
appear in at a several key points.

If you can't find that email, I'll resend.

Thanks,
Rick

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Thursday, February 07, 2008 2:53 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Multipath and getuid_callout issues
withHPXP1024diskarray

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Works fine, except for an odd issue at reboot times, for which I've
got
> a separate unanswered query out to this list.

Is it possible that your paths were not ready when multipath tried to
configure your paths as part of the boot process? Will they get
configured correctly when you restart the rc service (multipathd)?
If they get configured correctly when you run 'service multipathd
restart', I would assume that the problem is udev related, and a
udevsettle in the /etc/init.d/multipathd init script may help!

I am out of ideas and just shooting in the dark! :-)

--Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
