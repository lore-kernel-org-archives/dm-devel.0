From: Nikanth K <nikanth@gmail.com>
Subject: Re: [PATCH 14/14] barriers
Date: Tue, 24 Feb 2009 15:41:41 +0530
Message-ID: <807b3a220902240211k11b07d04s23856d0f60b34998@mail.gmail.com>
References: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
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

On Tue, Feb 24, 2009 at 12:53 AM, Mikulas Patocka <mpatocka@redhat.com> w=
rote:

<snip>

>
> +static int dm_flush(struct mapped_device *md)
> +{
> + =C2=A0 =C2=A0 =C2=A0 dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE)=
;
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +

Always returns zero! Why not void?

<snip>

Thanks
Nikanth
