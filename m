From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: path notification not working using on Suse SP2
Date: Mon, 11 Jul 2005 12:01:08 +0200
Message-ID: <20050711100108.GO19928@marowsky-bree.de>
References: <3456F611E9329441B12FBB24447B3FA0023F847F@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3456F611E9329441B12FBB24447B3FA0023F847F@bgeexc01.asiapacific.cpqcorp.net>
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

On 2005-07-08T17:45:20, "Murthy, Narasimha Doraswamy (STSD)" <narasimha.m=
urthy@hp.com> wrote:

Hi, posting to public mailing lists about bugs in our Release Candidate
products isn't very nice ;-) And, it's bound to be overlooked, because
during final product stages, monitoring public lists sort of takes a
back seat... Please use the Novell bugzilla via your partner processes
to file such bug reports.  Thanks.

> We have tried the same on Suse SP2- rc2, rc3 and rc4. The behaviour is
> the same, when the "readsector0" path checker is used for path
> verification.

This might be a side effect of bug #95907 which Ed reported, and which
was very recently fixed (well, ok, I committed the fix to our kernel 2
hours ago ;-).

But without logs, it's hard to say. Please, file a bugzilla report if
(the now released) SLES9 SP2 still exhibits the problem. And please also
try a kernel of the day from ftp.suse.com/pub/projects/kernel/ which
includes the fix for said bug in the changelog:

-------------------------------------------------------------------
Mon Jul 11 11:08:11 CEST 2005 - lmb@suse.de

- patches.fixes/sg_io_error_passing: Propagate errors correctly for
  SG_IO ops (#95907).


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
