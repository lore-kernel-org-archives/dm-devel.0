From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: multipath affinity to SCSI
Date: Wed, 27 Apr 2005 19:11:33 +0200
Message-ID: <20050427171133.GV4431@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A94C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A94C@SRMANNING.eng.emc.com>
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

On 2005-04-27T13:00:51, "goggin, edward" <egoggin@emc.com> wrote:

> Has anyone tried multipathing to non-SCSI target devices, e.g., LOOP,
> NBD, USB?  While the architecture looks fully capable of supporting
> such, it looks like both the kernel and user implementation would have
> some problems due to some SCSI affinity.

Well, I can see the user-space not auto-detecting the paths right now
(probably because simply noone has added those features yet ;-), but the
kernel shouldn't have any issues with it. I've played with it over loop
devices for testing.

Which SCSI affinity are you referring to?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
