From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] handle reada errors
Date: Sat, 22 Jan 2005 00:47:26 +0100
Message-ID: <20050121234726.GS25714@marowsky-bree.de>
References: <20050121172614.GR25714@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050121172614.GR25714@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2005-01-21T18:26:14, Lars Marowsky-Bree <lmb@suse.de> wrote:

> Silently ignore 'errors' for read ahead bios. They can fail in
> __make_request with a EWOULDBLOCK.=20

Just noticed this patch seems to be specific to the SUSE kernel. Sorry
about that, I keep losing track of what enhancements are already merged
upstream and which aren't yet ;-)

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
