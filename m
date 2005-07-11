From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: How to avoid lots of read ios to passive paths of
	active-passive storage devices?
Date: Mon, 11 Jul 2005 11:57:07 +0200
Message-ID: <20050711095707.GN19928@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321AB50@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB50@SRMANNING.eng.emc.com>
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

On 2005-07-08T00:21:21, "goggin, edward" <egoggin@emc.com> wrote:

> How sould device scanning utilities like blkid, pvscan,
> vgscan, and lvscan (others?) be made to avoid issuing
> a significant number of read ios to passive paths of
> active-passive storage devices?

Good question.

One could argue that if we issue a bd_claim() (I know, it's falling out
of favour ;-), we might want to issue a theoretical bd_claim_exclusive()
which excludes anyone else from messing with our precciiioussss: ie,
everybody else would be denied open().


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
