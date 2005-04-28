From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: what is the current utility in testing active paths
	from multipat hd?
Date: Thu, 28 Apr 2005 18:37:31 +0200
Message-ID: <20050428163731.GD21645@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
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

On 2005-04-27T12:27:32, "goggin, edward" <egoggin@emc.com> wrote:

> Although I know it sounds a bit radical and counter intuitive,
> but I'm not sure of the utility gained in the current multipathing
> implementation by multipathd periodically testing paths which
> are known to be in an active state in the multipath target driver.
> Possibly someone can convince me otherwise.

Ed, I misread your mail and missed the point. Your more succinct summary
on the conf call today made it all clear to me; indeed this doesn't just
need optimization, it needs fixing...

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D156280


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
