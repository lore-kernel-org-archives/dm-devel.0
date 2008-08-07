From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: Re: [PATCH] udev as of 0.124 doesn't support -s anymore
Date: Thu, 7 Aug 2008 10:47:38 +0200
Message-ID: <20080807084738.GB5809@bogon.ms20.nix>
References: <20080731101750.GA744@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080731101750.GA744@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 31, 2008 at 06:17:50AM -0400, Guido G=FCnther wrote:
> Hi,
> sysfs as of 0.124 doesn't support -s anymore and the whole sysfs code
> got removed, we'll have to use the devnodes in /dev/ from now on.  I
> also changed the last remaining call from /sbin/scsi_id to
> /lib/udev/scsi_id.
Ping. Everybody else shipping much older udev?
 -- Guido
