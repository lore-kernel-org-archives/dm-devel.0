From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v5 0/1] add option to output JSON for
 multipathd command
Date: Wed, 1 Jun 2016 17:05:58 +0200
Message-ID: <CABr-GnfT0VVgVniyhvzAj5-iTmVpFQ8798-Uim3YLbAUqaFxOA@mail.gmail.com>
References: <1464112987-11577-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4662371246476340598=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464112987-11577-1-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4662371246476340598==
Content-Type: multipart/alternative; boundary=001a1140f1a2b5f9e9053438d3f8

--001a1140f1a2b5f9e9053438d3f8
Content-Type: text/plain; charset=UTF-8

This v5 is merged.
Thanks.

On Tue, May 24, 2016 at 8:03 PM, Todd Gill <tgill@redhat.com> wrote:

> Hi,
>
> I had earlier sent an email to dm-devel proposing we add a feature
> in multipathd to output multipath map topology in JSON format. This
> patch contains to the code for that feature.
>
> Having an option for the  CLI to output in JSON would allow higher
> level applications to more easily monitor/manage multipath.
>
> I thought it was best to take advantage of some of the existing
> snprintf_xxx functions rather than adding a library dependency
> to multipathd.
>
> Any feedback welcome.
>
> v2:
> - added major/minor version fields
> - updates from feedback
> - added path groups
> - changed indent levels to make it easier to read
> - removed quotes from integer fields
> - fixed bug when the JSON string length exceeded the allocated memory
> - removed multipath field from path object - it isn't needed since
>   the path is inside the map
>
> v3:
> - split out vend/prod/rev into seperate fields
> - added new format specifiers for map:
>   %v - vend
>   %p - prod
>   %e - rev
> - removed vend/prod/rev from the path level since it is in the map
>
> v4:
> - removed space from major/minor version fields
>
> v5:
> - add group number at the group level
> - use an underscore to seperate words in the key part of the
> JSON
> - remove hcil, next_check, size, serial fields
> - remove uuid from the path level - it is already in the map
> - change JSON key from dm-st to dm_st
> - make all keys lower case
> - remove unnecessary call to memset - this addresses the performance
> problem.  memset is already called in MALLOC (zalloc)
> - multiply the initial allocation of memory with VECTOR_SIZE(vecs->mpvec)
> to reduce the number of realloc calls.
> - corrected reply + 1 in return of string length, correct length is
> c - reply, not c - reply + 1
>
> # multipathd show map dm-4 json
> {
>    "major_version": 0,
>    "minor_version": 1,
>    "map":{
>       "name" : "360a980004236646530244268305a3147",
>       "uuid" : "360a980004236646530244268305a3147",
>       "sysfs" : "dm-4",
>       "failback" : "immediate",
>       "queueing" : "on",
>       "paths" : 2,
>       "write_prot" : "rw",
>       "dm_st" : "active",
>       "features" : "4 queue_if_no_path pg_init_retries 50
> retain_attached_hw_handle",
>       "hwhandler" : "0",
>       "action" : "",
>       "path_faults" : 0,
>       "vend" : "NETAPP",
>       "prod" : "LUN",
>       "rev" : "811a",
>       "switch_grp" : 0,
>       "map_loads" : 1,
>       "total_q_time" : 0,
>       "q_timeouts" : 0,
>       "path_groups": [{
>          "selector" : "service-time 0",
>          "pri" : 50,
>          "dm_st" : "active",
>          "group" : 1,
>          "paths": [{
>             "dev" : "sdi",
>             "dev_t" : "8:128",
>             "dm_st" : "active",
>             "dev_st" : "running",
>             "chk_st" : "ready",
>             "checker" : "tur",
>             "pri" : 50,
>             "host_wwnn" : "0x50014380120d8425",
>             "target_wwnn" : "0x500a098080ba5a64",
>             "host_wwpn" : "0x50014380120d8424",
>             "target_wwpn" : "0x500a098180ba5a64",
>             "host_adapter" : "0000:00:03.0"
>          }]
>       },{
>          "selector" : "service-time 0",
>          "pri" : 10,
>          "dm_st" : "enabled",
>          "group" : 2,
>          "paths": [{
>             "dev" : "sdp",
>             "dev_t" : "8:240",
>             "dm_st" : "active",
>             "dev_st" : "running",
>             "chk_st" : "ready",
>             "checker" : "tur",
>             "pri" : 10,
>             "host_wwnn" : "0x50014380120d8427",
>             "target_wwnn" : "0x500a098080ba5a64",
>             "host_wwpn" : "0x50014380120d8426",
>             "target_wwpn" : "0x500a098190ba5a64",
>             "host_adapter" : "0000:00:03.0"
>          }]
>       }]
>    }
> }
>
> Todd Gill (1):
>   add display of map information in JSON format
>
>  libmultipath/print.c      | 222
> ++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/print.h      |  61 +++++++++++++
>  multipathd/cli.c          |   3 +
>  multipathd/cli.h          |   2 +
>  multipathd/cli_handlers.c |  93 +++++++++++++++++++
>  multipathd/cli_handlers.h |   2 +
>  multipathd/main.c         |   2 +
>  7 files changed, 385 insertions(+)
>
> --
> 2.5.5
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140f1a2b5f9e9053438d3f8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This v5 is merged.<div>Thanks.</div></div><div class=3D"gm=
ail_extra"><br><div class=3D"gmail_quote">On Tue, May 24, 2016 at 8:03 PM, =
Todd Gill <span dir=3D"ltr">&lt;<a href=3D"mailto:tgill@redhat.com" target=
=3D"_blank">tgill@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">Hi,<br>
<br>
I had earlier sent an email to dm-devel proposing we add a feature<br>
in multipathd to output multipath map topology in JSON format. This<br>
patch contains to the code for that feature.<br>
<br>
Having an option for the=C2=A0 CLI to output in JSON would allow higher<br>
level applications to more easily monitor/manage multipath.<br>
<br>
I thought it was best to take advantage of some of the existing<br>
snprintf_xxx functions rather than adding a library dependency<br>
to multipathd.<br>
<br>
Any feedback welcome.<br>
<br>
v2:<br>
- added major/minor version fields<br>
- updates from feedback<br>
- added path groups<br>
- changed indent levels to make it easier to read<br>
- removed quotes from integer fields<br>
- fixed bug when the JSON string length exceeded the allocated memory<br>
- removed multipath field from path object - it isn&#39;t needed since<br>
=C2=A0 the path is inside the map<br>
<br>
v3:<br>
- split out vend/prod/rev into seperate fields<br>
- added new format specifiers for map:<br>
=C2=A0 %v - vend<br>
=C2=A0 %p - prod<br>
=C2=A0 %e - rev<br>
- removed vend/prod/rev from the path level since it is in the map<br>
<br>
v4:<br>
- removed space from major/minor version fields<br>
<br>
v5:<br>
- add group number at the group level<br>
- use an underscore to seperate words in the key part of the<br>
JSON<br>
- remove hcil, next_check, size, serial fields<br>
- remove uuid from the path level - it is already in the map<br>
- change JSON key from dm-st to dm_st<br>
- make all keys lower case<br>
- remove unnecessary call to memset - this addresses the performance<br>
problem.=C2=A0 memset is already called in MALLOC (zalloc)<br>
- multiply the initial allocation of memory with VECTOR_SIZE(vecs-&gt;mpvec=
)<br>
to reduce the number of realloc calls.<br>
- corrected reply + 1 in return of string length, correct length is<br>
c - reply, not c - reply + 1<br>
<br>
# multipathd show map dm-4 json<br>
{<br>
=C2=A0 =C2=A0&quot;major_version&quot;: 0,<br>
=C2=A0 =C2=A0&quot;minor_version&quot;: 1,<br>
=C2=A0 =C2=A0&quot;map&quot;:{<br>
=C2=A0 =C2=A0 =C2=A0 &quot;name&quot; : &quot;360a980004236646530244268305a=
3147&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;uuid&quot; : &quot;360a980004236646530244268305a=
3147&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;sysfs&quot; : &quot;dm-4&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;failback&quot; : &quot;immediate&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;queueing&quot; : &quot;on&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;paths&quot; : 2,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;write_prot&quot; : &quot;rw&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;dm_st&quot; : &quot;active&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;features&quot; : &quot;4 queue_if_no_path pg_ini=
t_retries 50 retain_attached_hw_handle&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;hwhandler&quot; : &quot;0&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;action&quot; : &quot;&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;path_faults&quot; : 0,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;vend&quot; : &quot;NETAPP&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;prod&quot; : &quot;LUN&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;rev&quot; : &quot;811a&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;switch_grp&quot; : 0,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;map_loads&quot; : 1,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;total_q_time&quot; : 0,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;q_timeouts&quot; : 0,<br>
=C2=A0 =C2=A0 =C2=A0 &quot;path_groups&quot;: [{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;selector&quot; : &quot;service-time=
 0&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;pri&quot; : 50,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;dm_st&quot; : &quot;active&quot;,<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;group&quot; : 1,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;paths&quot;: [{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev&quot; : &quot;sdi&quot;=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev_t&quot; : &quot;8:128&q=
uot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dm_st&quot; : &quot;active&=
quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev_st&quot; : &quot;runnin=
g&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;chk_st&quot; : &quot;ready&=
quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;checker&quot; : &quot;tur&q=
uot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;pri&quot; : 50,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_wwnn&quot; : &quot;0x5=
0014380120d8425&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;target_wwnn&quot; : &quot;0=
x500a098080ba5a64&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_wwpn&quot; : &quot;0x5=
0014380120d8424&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;target_wwpn&quot; : &quot;0=
x500a098180ba5a64&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_adapter&quot; : &quot;=
0000:00:03.0&quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}]<br>
=C2=A0 =C2=A0 =C2=A0 },{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;selector&quot; : &quot;service-time=
 0&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;pri&quot; : 10,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;dm_st&quot; : &quot;enabled&quot;,<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;group&quot; : 2,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;paths&quot;: [{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev&quot; : &quot;sdp&quot;=
,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev_t&quot; : &quot;8:240&q=
uot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dm_st&quot; : &quot;active&=
quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;dev_st&quot; : &quot;runnin=
g&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;chk_st&quot; : &quot;ready&=
quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;checker&quot; : &quot;tur&q=
uot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;pri&quot; : 10,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_wwnn&quot; : &quot;0x5=
0014380120d8427&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;target_wwnn&quot; : &quot;0=
x500a098080ba5a64&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_wwpn&quot; : &quot;0x5=
0014380120d8426&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;target_wwpn&quot; : &quot;0=
x500a098190ba5a64&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;host_adapter&quot; : &quot;=
0000:00:03.0&quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}]<br>
=C2=A0 =C2=A0 =C2=A0 }]<br>
=C2=A0 =C2=A0}<br>
}<br>
<br>
Todd Gill (1):<br>
=C2=A0 add display of map information in JSON format<br>
<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 | 222 ++++++++++++++++++++++=
++++++++++++++++++++++++<br>
=C2=A0libmultipath/print.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 61 +++++++++++++<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<=
br>
=C2=A0multipathd/cli.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A02 +<=
br>
=C2=A0multipathd/cli_handlers.c |=C2=A0 93 +++++++++++++++++++<br>
=C2=A0multipathd/cli_handlers.h |=C2=A0 =C2=A02 +<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<=
br>
=C2=A07 files changed, 385 insertions(+)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.5.5<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--001a1140f1a2b5f9e9053438d3f8--


--===============4662371246476340598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4662371246476340598==--
