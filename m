From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Device Mapper as a cache for SAN?
Date: Mon, 10 Apr 2006 12:58:36 -0500
Message-ID: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

It seems like device-mapper would allow a fairly straightforward
implementation of a local-disk cache for a SAN (iSCSI, AOE, etc.). =20
The dm-raid1 and dm-mpath modules seem to have elements of overlap,
but its not clear if there's a straightforward way to implement a
local-disk block cache using existing modules, or whether a new one is
needed.  Has anyone looked at this before?

          -eric
