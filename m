From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH] Add dm-userspace target
Date: Thu, 15 Jun 2006 23:05:24 -0400
Message-ID: <E8C532D801BE5B479B28B626184E8CDD093627AC@tayexc14.americas.cpqcorp.net>
References: <m364j1x0ka.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <m364j1x0ka.fsf@guaranine.beaverton.ibm.com>
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

Oops, I just realize you are talking about the LVM portion of the
code... my bias is multipathing and thus my confusion... sorry


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Dan Smith
Sent: Thursday, June 15, 2006 11:05 PM
To: device-mapper development
Cc: stsd-securelinux-hp; Patterson, Andrew D (Linux R&D)
Subject: Re: [dm-devel] [PATCH] Add dm-userspace target

RS> Could you be more specific by the phrase of "block placement
RS> decisions" what placement are you referring too?

Sure.

So, take a complex format like qcow for example.  All of the data for
the disk is in the file, but clearly not in linear order, right?  Not
only is it non-linear, but it's in some form that requires some
understanding of a sophisticated set of metadata to linearize it.
But, since the data is just jumbled up, we can use device-mapper to
create a linear pseudo device that maps the linear blocks to their
correct location in the qcow file.  However, putting this logic in the
kernel is mildly ugly, and gets extremely ugly when you talk about
adding another format, such as vmdk, msvhd, etc.

With dm-userspace and the help of my userspace application (cowd), you
can mount these files as if they were normal disks in linux.

So, by giving a userspace application real-time control over the
mappings, we can push the complexity into userspace.  There are a lot
of other nifty things you can do from the comfort of userspace once
you have this generic enabler in the kernel to act on your behalf.
*Lots* :)

--=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
