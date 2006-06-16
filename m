From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH] Add dm-userspace target
Date: Thu, 15 Jun 2006 22:36:32 -0400
Message-ID: <E8C532D801BE5B479B28B626184E8CDD093627A5@tayexc14.americas.cpqcorp.net>
References: <m37j3i1kbq.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <m37j3i1kbq.fsf@guaranine.beaverton.ibm.com>
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
Cc: stsd-securelinux-hp <stsd-securelinux-hp@hp.com>, "Patterson,  Andrew D (Linux R&D)" <andrew.patterson@hp.com>
List-Id: dm-devel.ids

Could you be more specific by the phrase of "block placement decisions"
what placement are you referring too?=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Dan Smith
Sent: Thursday, June 15, 2006 11:59 AM
To: device-mapper development
Cc: Ryan Grimm
Subject: [dm-devel] [PATCH] Add dm-userspace target

This patch adds the dm-userspace target to the kernel.  I have tested
it successfully on both i386 and x86_64 SMP machines.

The idea of dm-userspace is to export an interface for userspace
control over device-mapper block placement decisions.  It effectively
allows device-mapper target logic to be implemented in userspace.

I have a library that provides a simple record-based userspace
interface for communication with a dm-userspace target, available
here:

  http://static.danplanet.com/dm-userspace/libdmu-0.3.tar.gz

The library tarball also contains an example.c, which demonstrates how
to write a userspace application (in about 16 lines of actual code).

I would really like feedback about the kernel module.  I'm definitely
willing to do whatever work is needed to make this an acceptable part
of device-mapper.
