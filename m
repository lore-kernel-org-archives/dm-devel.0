From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH 2/6] libmultipath: make sysfs_is_multipathed
 able to return wwid
Date: Fri, 15 May 2020 22:36:57 +0200
Message-ID: <126a59ed3668d8992ea8a2565de212c13edfcde2.camel@suse.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589507962-6895-3-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> sysfs_is_multipathed reads the wwid of the dm device holding a path
> to
> check if its a multipath device.  Add code to optinally set pp->wwid
> to
> that wwid.  This will be used by a future patch.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
