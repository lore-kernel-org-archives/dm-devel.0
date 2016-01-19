From: Brian Bunker <brian@purestorage.com>
Subject: Re: Question about multipath device compiled defaults
Date: Tue, 19 Jan 2016 14:17:39 -0800
Message-ID: <CAHZQxyLmSQq89=P4b+rehQhWtU8eC4KO4rxaPzmDv5uZ0p7B2A@mail.gmail.com>
References: <201511050700.tA570XNA029270@d06av02.portsmouth.uk.ibm.com>
	<569E65D4.4020002@linux.vnet.ibm.com>
	<CABr-GneOyHJNiQRywzdKq5rr5S7Ljz4up3W=V_HgHoUtfY=C3g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6126659575084078757=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneOyHJNiQRywzdKq5rr5S7Ljz4up3W=V_HgHoUtfY=C3g@mail.gmail.com>
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

--===============6126659575084078757==
Content-Type: multipart/alternative; boundary=001a1141e9b6ca8d630529b73c17

--001a1141e9b6ca8d630529b73c17
Content-Type: text/plain; charset=UTF-8

There are just two files I touch, so the patch is simple:

diff -Naur 3/multipath-tools/libmultipath/hwtable.c
4/multipath-tools/libmultipath/hwtable.c
--- 3/multipath-tools/libmultipath/hwtable.c    2016-01-14
17:47:06.000000000 -0800
+++ 4/multipath-tools/libmultipath/hwtable.c    2016-01-14
18:33:45.000000000 -0800
@@ -1166,6 +1166,22 @@
                .prio_name     = PRIO_ALUA,
                .prio_args     = NULL,
        },
+        {
+               .vendor        = "PURE",
+               .product       = "FlashArray",
+               .features      = DEFAULT_FEATURES,
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = "queue-length 0",
+               .pgpolicy      = MULTIBUS,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .checker_name  = TUR,
+               .fast_io_fail  = 10,
+                .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
+               .prio_name     = DEFAULT_PRIO,
+                .no_path_retry = 0,
+                .dev_loss      = 60,
+               .prio_args     = NULL,
+       },
        /*
         * EOL
         */
diff -Naur 3/multipath-tools/multipath.conf.defaults
4/multipath-tools/multipath.conf.defaults
--- 3/multipath-tools/multipath.conf.defaults   2016-01-14
17:47:06.000000000 -0800
+++ 4/multipath-tools/multipath.conf.defaults   2016-01-14
18:35:50.000000000 -0800
@@ -940,6 +940,17 @@
 #              rr_weight "uniform"
 #              no_path_retry "queue"
 #      }
+#       device {
+#               vendor "PURE"
+#               path_selector "queue-length 0"
+#               path_grouping_policy "multibus"
+#               path_checker "tur"
+#               fast_io_fail_tmo 10
+#               user_friendly_names "no"
+#               no_path_retry 0
+#               features 0
+#               dev_loss_tmo 60
+#       }
 #}
 #multipaths {
 #}


Thanks,
Brian

On Tue, Jan 19, 2016 at 8:48 AM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Hi,
>
> and when you are ready, you can post the patch here so I can merge it
> upstream.
>
> Thanks,
> Christophe Varoqui
> OpenSVC
>
> On Tue, Jan 19, 2016 at 5:35 PM, Mauricio Faria de Oliveira <
> mauricfo@linux.vnet.ibm.com> wrote:
>
>> On 11/05/2015 04:59 AM, Doron Tal1 wrote:
>>
>>> I would like to know how and what procedure i should follow if i want to
>>> modify or add new settings to the device mapper defaults.
>>>
>>
>> The defaults are in hwtable.c [1].
>>
>> So for example how can i modify existing compiled settings for the
>>> 2810XIV device? in case i want to add a new device and it settings, how
>>> can it be done?
>>>
>>
>> To modify the compiled settings, you have to modify it and recompile.
>>
>> To modify the runtime settings (based on the defaults), you can modify
>> /etc/multipath.conf (see its manpage [2] with 'man multipath.conf').
>>
>> You can verify the the setting values used during multipath discovery
>> with 'multipath -v3' for example, or "multipathd -k'show config'".
>>
>> Hope this might still help at this time,
>>
>> [1]
>> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c
>> [2]
>> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=multipath/multipath.conf.5
>>
>> --
>> Mauricio Faria de Oliveira
>> IBM Linux Technology Center
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Brian Bunker
PURE Storage, Inc. <http://www.purestorage.com>
brian@purestorage.com

--001a1141e9b6ca8d630529b73c17
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">There are just two files I touch, so the patch is simple:<=
div><br></div><div><div>diff -Naur 3/multipath-tools/libmultipath/hwtable.c=
 4/multipath-tools/libmultipath/hwtable.c</div><div>--- 3/multipath-tools/l=
ibmultipath/hwtable.c =C2=A0 =C2=A02016-01-14 17:47:06.000000000 -0800</div=
><div>+++ 4/multipath-tools/libmultipath/hwtable.c =C2=A0 =C2=A02016-01-14 =
18:33:45.000000000 -0800</div><div>@@ -1166,6 +1166,22 @@</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name =C2=A0 =C2=A0 =
=3D PRIO_ALUA,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 .prio_args =C2=A0 =C2=A0 =3D NULL,</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 },</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0{</div><div>+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D &quot;PURE&quot;,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 .product =C2=A0 =C2=A0 =C2=A0 =3D &quot;FlashArray&quot;,</div><div=
>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .features =C2=A0 =C2=A0=
 =C2=A0=3D DEFAULT_FEATURES,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 .hwhandler =C2=A0 =C2=A0 =3D DEFAULT_HWHANDLER,</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .selector =C2=A0 =C2=A0 =
=C2=A0=3D &quot;queue-length 0&quot;,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy =C2=A0 =C2=A0 =C2=A0=3D MULTIBUS,</div><=
div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback =C2=A0 =
=C2=A0=3D -FAILBACK_IMMEDIATE,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 .checker_name =C2=A0=3D TUR,</div><div>+ =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fast_io_fail =C2=A0=3D 10,</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_friendly_names=
 =3D USER_FRIENDLY_NAMES_OFF,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 .prio_name =C2=A0 =C2=A0 =3D DEFAULT_PRIO,</div><div>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D 0=
,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.dev_l=
oss =C2=A0 =C2=A0 =C2=A0=3D 60,</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 .prio_args =C2=A0 =C2=A0 =3D NULL,</div><div>+ =C2=A0 =C2=
=A0 =C2=A0 }, =C2=A0 =C2=A0 =C2=A0 =C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /*</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* EOL</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/</div><div>diff -Naur 3/multipath-tools/mu=
ltipath.conf.defaults 4/multipath-tools/multipath.conf.defaults</div><div>-=
-- 3/multipath-tools/multipath.conf.defaults =C2=A0 2016-01-14 17:47:06.000=
000000 -0800</div><div>+++ 4/multipath-tools/multipath.conf.defaults =C2=A0=
 2016-01-14 18:35:50.000000000 -0800</div><div>@@ -940,6 +940,17 @@</div><d=
iv>=C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rr_weight &quot;=
uniform&quot;</div><div>=C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0no_path_retry &quot;queue&quot;</div><div>=C2=A0# =C2=A0 =C2=A0 =C2=
=A0}</div><div>+# =C2=A0 =C2=A0 =C2=A0 device {</div><div>+# =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &quot;PURE&quot;</div><div>+# =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_selector &quot;queue-len=
gth 0&quot;</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p=
ath_grouping_policy &quot;multibus&quot;</div><div>+# =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 path_checker &quot;tur&quot;</div><div>+# =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fast_io_fail_tmo 10</div><div=
>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user_friendly_names &q=
uot;no&quot;</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
no_path_retry 0</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 features 0</div><div>+# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 dev_loss_tmo 60</div><div>+# =C2=A0 =C2=A0 =C2=A0 }</div><div>=C2=A0#}<=
/div><div>=C2=A0#multipaths {</div><div>=C2=A0#}</div></div><div><br></div>=
<div><br></div><div>Thanks,<br>Brian</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Jan 19, 2016 at 8:48 AM, Christophe =
Varoqui <span dir=3D"ltr">&lt;<a href=3D"mailto:christophe.varoqui@opensvc.=
com" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi,</div><div><br>=
</div>and when you are ready, you can post the patch here so I can merge it=
 upstream.<div><br></div><div>Thanks,</div><div>Christophe Varoqui</div><di=
v>OpenSVC</div></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jan 19, 2016 at 5:35 PM=
, Mauricio Faria de Oliveira <span dir=3D"ltr">&lt;<a href=3D"mailto:mauric=
fo@linux.vnet.ibm.com" target=3D"_blank">mauricfo@linux.vnet.ibm.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span>On 11/05/2015 04:59=
 AM, Doron Tal1 wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
I would like to know how and what procedure i should follow if i want to<br=
>
modify or add new settings to the device mapper defaults.<br>
</blockquote>
<br></span>
The defaults are in hwtable.c [1].<span><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
So for example how can i modify existing compiled settings for the<br>
2810XIV device? in case i want to add a new device and it settings, how<br>
can it be done?<br>
</blockquote>
<br></span>
To modify the compiled settings, you have to modify it and recompile.<br>
<br>
To modify the runtime settings (based on the defaults), you can modify<br>
/etc/multipath.conf (see its manpage [2] with &#39;man multipath.conf&#39;)=
.<br>
<br>
You can verify the the setting values used during multipath discovery<br>
with &#39;multipath -v3&#39; for example, or &quot;multipathd -k&#39;show c=
onfig&#39;&quot;.<br>
<br>
Hope this might still help at this time,<br>
<br>
[1] <a href=3D"http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=
=3Dblob;f=3Dlibmultipath/hwtable.c" rel=3D"noreferrer" target=3D"_blank">ht=
tp://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dlibmu=
ltipath/hwtable.c</a><br>
[2] <a href=3D"http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=
=3Dblob;f=3Dmultipath/multipath.conf.5" rel=3D"noreferrer" target=3D"_blank=
">http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dm=
ultipath/multipath.conf.5</a><span><font color=3D"#888888"><br>
<br>
-- <br>
Mauricio Faria de Oliveira<br>
IBM Linux Technology Center<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>
</div></div><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div cla=
ss=3D"gmail_signature"><div>Brian Bunker</div><div><a href=3D"http://www.pu=
restorage.com" target=3D"_blank">PURE Storage, Inc.</a><br></div><div><a hr=
ef=3D"mailto:brian@purestorage.com" target=3D"_blank">brian@purestorage.com=
</a></div></div>
</div>

--001a1141e9b6ca8d630529b73c17--


--===============6126659575084078757==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6126659575084078757==--
