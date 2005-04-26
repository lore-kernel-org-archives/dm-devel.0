From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Update: Disk io deadlocks during large-file io
Date: Tue, 26 Apr 2005 20:57:41 +0200
Message-ID: <20050426185741.GK7859@marowsky-bree.de>
References: <4267F307.8080009@karett.se> <426E76BB.2060201@karett.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <426E76BB.2060201@karett.se>
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
Cc: axboe@suse.de
List-Id: dm-devel.ids

On 2005-04-26T19:13:31, Mikael Andersson <mikael@karett.se> wrote:

> With md raid1 instead of dm-mirror i get no lockups during similar
> workloads or any other workload i've managed to produce. Everything is
> the same except that i'm using md instead of dm-mirror.

That's not very surprising. md is still the preferred framework for
raidN as of now, and I'm not sure that will change soon.

(Yes, consolidating the stack and everything would be nice, but I don't
see anyone with time on his hands to go do it ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
