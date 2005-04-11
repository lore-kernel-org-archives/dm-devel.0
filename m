From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH]  rm alloc_page from dm-emc take 2
Date: Mon, 11 Apr 2005 14:00:46 +0200
Message-ID: <20050411120046.GK12752@marowsky-bree.de>
References: <425A6145.7010302@cs.wisc.edu> <425A63FC.1060808@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <425A63FC.1060808@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mikenc@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2005-04-11T04:48:12, Mike Christie <mikenc@us.ibm.com> wrote:

> >+	if (bio_add_page(bio, virt_to_page(data), data_size,
> >+			 offset_in_page(data)) !=3D data_size) {
> My concern though is that I do no think I can do this. I mean we cannot=
=20
> start the IO from the middle of a page.

I asked on #kernel, and supposedly this is allowed.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
