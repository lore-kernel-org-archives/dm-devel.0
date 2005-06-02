From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: BIO_RW_FAILFAST
Date: Thu, 2 Jun 2005 18:41:23 +0200
Message-ID: <20050602164123.GE22633@marowsky-bree.de>
References: <20050517205915.GA27652@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050517205915.GA27652@thumper2>
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

On 2005-05-17T15:59:15, Andy <genanr@emsphone.com> wrote:

> I have been having problems with systems getting I/O errors and droppin=
g
> mounted filesystems, when it is processing a RCSN caused by some other =
event
> on the fabric within its' zone.  If I unset BIO_RW_FAILFAST in dm-mpath=
.c I
> no longer get the I/O errors and of course no filesystem drops.  Are th=
ere
> any plans to change this, or make it a settable option?  Are there any
> negatives to not setting it?

What is "RCSN"? What hardware? And why does it show up on all paths at
once?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
