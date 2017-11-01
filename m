From: Tariq Mustafa <tmustafa@hotmail.com>
Subject: Re: Replacement for dm_dispatch_request for older
 request based targets
Date: Wed, 1 Nov 2017 18:10:58 +0000
Message-ID: <BY2PR18MB03442D771B14B459A7319095C25F0@BY2PR18MB0344.namprd18.prod.outlook.com>
References: <BY2PR18MB03446D72103BA92941E3CF46C25F0@BY2PR18MB0344.namprd18.prod.outlook.com>,
	<20171101160857.GA25886@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0733891375843044665=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171101160857.GA25886@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0733891375843044665==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY2PR18MB03442D771B14B459A7319095C25F0BY2PR18MB0344namp_"

--_000_BY2PR18MB03442D771B14B459A7319095C25F0BY2PR18MB0344namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks Mike. I was looking at the request based crypt, and saw the followin=
g code;


static void req_crypt_dec_pending_encrypt(struct req_dm_crypt_io *io)
{
        int error =3D 0;
        struct request *clone =3D NULL;

        if (io) {
                error =3D io->error;
                if (io->cloned_request) {
                        clone =3D io->cloned_request;
                } else {
                ....

                }
        } else {

                ....
        }

        atomic_dec(&io->pending);

        if (error < 0)
                dm_kill_unmapped_request(clone, error);
        else
                dm_dispatch_request(clone);    <----
}


Here I think the request is being sent to the underlying device below the t=
arget (I think the .map_rq would be returning DM_MAPIO_REMAPPED for this IO=
). Now with "dm_dispatch_request()" deprecated, how would this be done now?


Additional question:

Also for bio based targets, there is a facility within target to allocate s=
ome space using the "per_bio_data_size", and then use that in the "map" cal=
lback using the "dm_per_bio_data()", do we have an equivalent mechanism for=
 request based targets. I saw some patch where there are there is something=
 about letting request based targets to use this ("per_io_data_size"), but =
I did not see anything the version of kernel that I have - Ubuntu 16.04 (4.=
4.0-92).


Thank you!

________________________________
From: Mike Snitzer <snitzer@redhat.com>
Sent: Wednesday, November 1, 2017 9:08:57 AM
To: Tariq Mustafa
Cc: dm-devel@redhat.com
Subject: Re: Replacement for dm_dispatch_request for older request based ta=
rgets

On Wed, Nov 01 2017 at  2:23am -0400,
Tariq Mustafa <tmustafa@hotmail.com> wrote:

>    Hello,
>
>    I am trying to figure out what would be the appropriate replacement fo=
r
>    "dm_dispatch_request()" on the newer kernel? This export has been remo=
ved
>    (by commit - [1][dbf978]), what would be an equivalent call to submit =
the
>    request.

dm_dispatch_request was renamed to dm_dispatch_clone_request (IIRC).

But are you asking what is the new export?  There isn't one.  There
should be no need for anything other than DM core (dm-rq.c) to call
these interfaces that are no longer exported.

Please explain what you're trying to do if you need more help.

Thanks,
Mike

--_000_BY2PR18MB03442D771B14B459A7319095C25F0BY2PR18MB0344namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<meta content=3D"text/html; charset=3DUTF-8">
<style type=3D"text/css" style=3D"">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size:12pt; col=
or:#000000; font-family:Calibri,Helvetica,sans-serif">
<p>Thanks Mike. I was looking at the request based crypt, and saw the follo=
wing code;</p>
<p><br>
</p>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap">static void req_c=
rypt_dec_pending_encrypt(struct req_dm_crypt_io *io)=0A=
{=0A=
	int error =3D 0;=0A=
	struct request *clone =3D NULL;=0A=
=0A=
	if (io) {=0A=
		error =3D io-&gt;error;=0A=
		if (io-&gt;cloned_request) {=0A=
			clone =3D io-&gt;cloned_request;=0A=
		} else {=0A=
                ....</pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap">        	}=0A=
	} else {</pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap">                .=
...=0A=
	}=0A=
=0A=
	atomic_dec(&amp;io-&gt;pending);=0A=
=0A=
	if (error &lt; 0)=0A=
		dm_kill_unmapped_request(clone, error);=0A=
	else=0A=
		dm_dispatch_request(clone);    &lt;----=0A=
}</pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><br></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap">Here I think the =
request is being sent to the underlying device below the target (I think th=
e .map_rq would be returning DM_MAPIO_REMAPPED for this IO)<span style=3D"f=
ont-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Col=
or Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Sym=
bol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt">. Now wit=
h &quot;dm_dispatch_request()&quot; deprecated, how would this be done now?=
</span></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><span style=3D"fo=
nt-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Colo=
r Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Symb=
ol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt"><br></span=
></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><span style=3D"fo=
nt-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Colo=
r Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Symb=
ol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt">Additional=
 question:</span></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><span style=3D"fo=
nt-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Colo=
r Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Symb=
ol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt">Also for b=
io based targets, there is a facility within target to allocate some space =
using the &quot;per_bio_data_size&quot;, and then use that in the &quot;map=
&quot; callback using the &quot;dm_per_bio_data()&quot;, do we have an equi=
valent mechanism for request based targets. I saw some patch where there ar=
e there is something about letting request based targets to use this (&quot=
;per_io_data_size&quot;), but I did not see anything the version of kernel =
that I have - Ubuntu 16.04 (4.4.0-92).</span></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><span style=3D"fo=
nt-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Colo=
r Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Symb=
ol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt"><br></span=
></pre>
<pre style=3D"word-wrap:break-word; white-space:pre-wrap"><span style=3D"fo=
nt-family:Calibri,Helvetica,sans-serif,Helvetica,EmojiFont,&quot;Apple Colo=
r Emoji&quot;,&quot;Segoe UI Emoji&quot;,NotoColorEmoji,&quot;Segoe UI Symb=
ol&quot;,&quot;Android Emoji&quot;,EmojiSymbols; font-size:12pt">Thank you!=
</span></pre>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>From:</b> Mike Snitzer &lt;sn=
itzer@redhat.com&gt;<br>
<b>Sent:</b> Wednesday, November 1, 2017 9:08:57 AM<br>
<b>To:</b> Tariq Mustafa<br>
<b>Cc:</b> dm-devel@redhat.com<br>
<b>Subject:</b> Re: Replacement for dm_dispatch_request for older request b=
ased targets</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">On Wed, Nov 01 2017 at&nbsp; 2:23am -0400,<br>
Tariq Mustafa &lt;tmustafa@hotmail.com&gt; wrote:<br>
<br>
&gt;&nbsp;&nbsp;&nbsp; Hello,<br>
&gt; <br>
&gt;&nbsp;&nbsp;&nbsp; I am trying to figure out what would be the appropri=
ate replacement for<br>
&gt;&nbsp;&nbsp;&nbsp; &quot;dm_dispatch_request()&quot; on the newer kerne=
l? This export has been removed<br>
&gt;&nbsp;&nbsp;&nbsp; (by commit - [1][dbf978]), what would be an equivale=
nt call to submit the<br>
&gt;&nbsp;&nbsp;&nbsp; request.<br>
<br>
dm_dispatch_request was renamed to dm_dispatch_clone_request (IIRC).<br>
<br>
But are you asking what is the new export?&nbsp; There isn't one.&nbsp; The=
re<br>
should be no need for anything other than DM core (dm-rq.c) to call<br>
these interfaces that are no longer exported.<br>
<br>
Please explain what you're trying to do if you need more help.<br>
<br>
Thanks,<br>
Mike<br>
</div>
</span></font>
</body>
</html>

--_000_BY2PR18MB03442D771B14B459A7319095C25F0BY2PR18MB0344namp_--


--===============0733891375843044665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0733891375843044665==--
