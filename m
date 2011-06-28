From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt TRIM support
Date: Tue, 28 Jun 2011 23:19:01 +0200
Message-ID: <4E0A4545.6070401@redhat.com>
References: <4E0A3EF2.4090608@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E0A3EF2.4090608@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@deserettechnology.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/28/2011 10:52 PM, Jeff Cook wrote:
> After mounting a LUKS partition on my SSD, I get a message that the
> discard mount option is ignored. In my research, I have seen many
> conflicting reports on whether this functionality was available or not.
> The last reliable mail I can find was from January and indicated that an
> expected release of configurable discard support over dm-crypt in
> 2.6.39. Can anyone let me know if this target was reached, and if not,
> where development on TRIM support for dm-crypt volumes currently stands?

right, dm-crypt doesn't support TRIM yet.

I would like to add optional support for it but no code is submitted yet.
No ETA currently.

Milan
