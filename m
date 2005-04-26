From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: nit with reinstate_path for dm-mpath.c
Date: Tue, 26 Apr 2005 12:01:40 +0200
Message-ID: <20050426100140.GG32085@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A93F@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A93F@SRMANNING.eng.emc.com>
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

On 2005-04-25T15:25:36, "goggin, edward" <egoggin@emc.com> wrote:

> Should reinstate_path() in dm-mpath.c only conditionally reset
> current_pgpath if the restored path is in the same path priority group
> as the current_pgpath instead of doing so unconditionally as is done
> currently?

> Albeit this change makes sense IFF it is architecturally
> invalid to have a path selection policy which spans multiple path
> priority groups -- as I think is currently the case.

Agreed. I think the setting of current_pgpath =3D NULL; dates back to the
times where we always switched to the highest priority group if it had
any available paths.

While it doesn't have any bad side effects (beyond invoking the
__choose_pgpath()), it's a cleanup and optimization to remove that
line.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
