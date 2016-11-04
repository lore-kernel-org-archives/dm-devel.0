From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath bug and patch
Date: Fri, 4 Nov 2016 11:45:31 -0500
Message-ID: <20161104164531.GH1972@octiron.msp.redhat.com>
References: <CALRmJ1tJvjrVe9V9ZTeX+K-R9BMVf9wzbVVY5PV5jSXU3EG6Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALRmJ1tJvjrVe9V9ZTeX+K-R9BMVf9wzbVVY5PV5jSXU3EG6Fg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Shoemaker <james@dhlake.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 03, 2016 at 01:34:17PM -0500, James Shoemaker wrote:
>    =A0=A0 If a device returns an empty string for inquiry data the current
>    multipath tool ignores it on reload.=A0 I added the following patch an=
d I
>    can hotplug these devices that don't return all the proper data.

I feel like returning "none" if you try and strchop an empty string is
pretty surprising behavior. I'd rather see this dealt with in the
function that has problems with the empty string.

-Ben

> =

>    diff --git a/libmultipath/util.c b/libmultipath/util.c
>    index ac0d1b2..045e660 100644
>    --- a/libmultipath/util.c
>    +++ b/libmultipath/util.c
>    @@ -17,6 +17,10 @@ strchop(char *str)
>    =A0
>    =A0=A0=A0=A0=A0=A0=A0 for (i=3Dstrlen(str)-1; i >=3D0 && isspace(str[i=
]); --i) ;
>    =A0=A0=A0=A0=A0=A0=A0 str[++i] =3D '\0';
>    +=A0=A0=A0=A0=A0=A0 if(strlen(str)=3D=3D0)
>    +=A0=A0=A0=A0=A0=A0 {
>    +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strcpy(str,"none");
>    +=A0=A0=A0=A0=A0=A0 }
>    =A0=A0=A0=A0=A0=A0=A0 return strlen(str);
>    =A0}
> =

>    James Shoemaker

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
