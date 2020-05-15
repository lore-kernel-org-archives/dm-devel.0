From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 5/6] libmultipath: simplify failed wwid code
Date: Fri, 15 May 2020 20:38:09 +0000
Message-ID: <6edf2f5f3a74e16fa63cc108b6edba98d0b269b5.camel@suse.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589507962-6895-6-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <DD79533A5BEA9741AB84220BDD7F9DC8@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> The (is|mark|unmark)_failed_wwid code is needlessly complicated.
> Locking a file is necssary if multiple processes could otherwise be
> writing to it at the same time. That is not the case with the
> failed_wwids files. They can simply be empty files in a
> directory.  Even
> with all the locking in place, two processes accessing or modifying a
> file at the same time will still race. And even without the locking,
> if
> two processes try to access or modify a file at the same time, they
> will
> both see a reasonable result, and will leave the files in a valid
> state
> afterwards.
>=20
> Instead of doing all the locking work (which made it necessary to
> write
> a file, even just to check if a file existed), simply check for files
> with lstat(), create them with open(), and remove them with unlink().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

With the follow-up (6/6):
Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
