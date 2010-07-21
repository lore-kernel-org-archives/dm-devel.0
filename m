From: W S <whatisee1@yahoo.com>
Subject: Re: [BUG] please PLEASE UnSubscribe!!!
Date: Tue, 20 Jul 2010 20:04:45 -0700 (PDT)
Message-ID: <649898.4332.qm@web57601.mail.re1.yahoo.com>
References: <20100720220644.GA25337@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3319683933538943845=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100720220644.GA25337@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============3319683933538943845==
Content-Type: multipart/alternative; boundary="0-662700756-1279681485=:4332"

--0-662700756-1279681485=:4332
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

please PLEASE UnSubscribe!!!

--- On Tue, 7/20/10, Malahal Naineni <malahal@us.ibm.com> wrote:

From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [dm-devel] [BUG] multipath-tools: uuid has become meaningless
To: dm-devel@redhat.com
Date: Tuesday, July 20, 2010, 3:06 PM

Hannes Reinecke [hare@suse.de] wrote:
> Malahal Naineni wrote:
> > This is where I was heading. I did some investigation and found that we
> > really need to rename to wwid based names before we finally rename to
> > the intended name. So we may actually have two passes just to rename
> > (first to wwid based names and then to actual names).=A0 Also the curre=
nt
> > code doesn't do rename followed by reload even if it is needed. Someone
> > sets friendly name and some other defaults that need reload like path
> > grouping policy etc, we just rename! Probably a bug in itself.

> You sure? I would rather rely on device-mapper uuids here.

Hannes, I am not sure what you are referring to when you say, "You
sure?" Are you saying if I am sure about this bug? If so, you can see
yourself by swapping couple entries in the bindings file. As I said,
you will notice this bug only when you enable 'user_friendly_names' in
initrd in real life!

> So we can use the known naming scheme for the uuid to regenerate the
> wwid; with this we can identify/access the device and we should be able t=
o
> make do with just one pass.

Say, you have "mpath0[uuid0]" and "mpath1[uuid1]" loaded currently.=A0 How
can we rename mpath0 to mpath1 and vice-versa? It does require an
intermediate step of renaming to something else, right?=20
=20
Thanks, Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
=0A=0A=0A      
--0-662700756-1279681485=:4332
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;">please PLEASE UnSubscribe!!!<br><br>--- On <b=
>Tue, 7/20/10, Malahal Naineni <i>&lt;malahal@us.ibm.com&gt;</i></b> wrote:=
<br><blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-le=
ft: 5px; padding-left: 5px;"><br>From: Malahal Naineni &lt;malahal@us.ibm.c=
om&gt;<br>Subject: Re: [dm-devel] [BUG] multipath-tools: uuid has become me=
aningless<br>To: dm-devel@redhat.com<br>Date: Tuesday, July 20, 2010, 3:06 =
PM<br><br><div class=3D"plainMail">Hannes Reinecke [<a ymailto=3D"mailto:ha=
re@suse.de" href=3D"/mc/compose?to=3Dhare@suse.de">hare@suse.de</a>] wrote:=
<br>&gt; Malahal Naineni wrote:<br>&gt; &gt; This is where I was heading. I=
 did some investigation and found that we<br>&gt; &gt; really need to renam=
e to wwid based names before we finally rename to<br>&gt; &gt; the intended=
 name. So we may actually have two passes just to rename<br>&gt; &gt; (firs=
t to wwid
 based names and then to actual names).&nbsp; Also the current<br>&gt; &gt;=
 code doesn't do rename followed by reload even if it is needed. Someone<br=
>&gt; &gt; sets friendly name and some other defaults that need reload like=
 path<br>&gt; &gt; grouping policy etc, we just rename! Probably a bug in i=
tself.<br><br>&gt; You sure? I would rather rely on device-mapper uuids her=
e.<br><br>Hannes, I am not sure what you are referring to when you say, "Yo=
u<br>sure?" Are you saying if I am sure about this bug? If so, you can see<=
br>yourself by swapping couple entries in the bindings file. As I said,<br>=
you will notice this bug only when you enable 'user_friendly_names' in<br>i=
nitrd in real life!<br><br>&gt; So we can use the known naming scheme for t=
he uuid to regenerate the<br>&gt; wwid; with this we can identify/access th=
e device and we should be able to<br>&gt; make do with just one pass.<br><b=
r>Say, you have "mpath0[uuid0]" and "mpath1[uuid1]" loaded
 currently.&nbsp; How<br>can we rename mpath0 to mpath1 and vice-versa? It =
does require an<br>intermediate step of renaming to something else, right? =
<br> <br>Thanks, Malahal.<br><br>--<br>dm-devel mailing list<br><a ymailto=
=3D"mailto:dm-devel@redhat.com" href=3D"/mc/compose?to=3Ddm-devel@redhat.co=
m">dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.com/mailman/lis=
tinfo/dm-devel" target=3D"_blank">https://www.redhat.com/mailman/listinfo/d=
m-devel</a><br></div></blockquote></td></tr></table><br>=0A=0A      
--0-662700756-1279681485=:4332--


--===============3319683933538943845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3319683933538943845==--
