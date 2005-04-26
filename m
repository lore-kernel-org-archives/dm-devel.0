From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Should enhanced bio error state be propagated upwards
	to parent o f failed cloned bios?
Date: Tue, 26 Apr 2005 11:57:16 +0200
Message-ID: <20050426095716.GF32085@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A93A@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A93A@SRMANNING.eng.emc.com>
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

On 2005-04-25T11:34:32, "goggin, edward" <egoggin@emc.com> wrote:

> Should the bi_error field of a failed bio clone completion be propagate=
d
> upwards into the parent of the cloned bio, possibly in dec_pending() of
> dm.c?  Doing so will allow target drivers higher than the one managing
> the bottom-most mapped device to have access to enhanced bio sense
> and error information.  Otherwise, all they see is -EIO like now.

Probably yes. Good point.

Right now only dm-mpath knows about them of course, and we're very
likely to be the lowest mapped device in the stack. But propagating the
error upward might make sense.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
