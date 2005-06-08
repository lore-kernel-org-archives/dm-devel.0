From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] [2.6.12-rc6-mm1] Handle READA requests in
	dm-mpath.c
Date: Wed, 8 Jun 2005 14:13:04 +0200
Message-ID: <20050608121304.GU27119@marowsky-bree.de>
References: <20050608110436.GQ27119@marowsky-bree.de>
	<20050608043347.5db85317.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050608043347.5db85317.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On 2005-06-08T04:33:47, Andrew Morton <akpm@osdl.org> wrote:

> Lars Marowsky-Bree <lmb@suse.de> wrote:
> >
> > READA errors failing with EWOULDBLOCK/EAGAIN do not constitute a vali=
d
> > reason for failing the path; this lead to erratic errors on DM multip=
ath
> > devices. This error can be safely propagated upwards without failing =
the
> > path.
> >=20
>=20
> Why do you describe this as a -mm patch?  We want this in 2.6.12, no?

Uhm, right. I just diff'ed it against -mm out of habit, I guess, because
I also assumed you were the fastest path to Linus ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
