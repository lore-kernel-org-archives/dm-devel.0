From: Michael McCarthy <mccarthy197310@gmail.com>
Subject: Re: Question about merge performance
Date: Thu, 23 Mar 2017 22:29:58 -0400
Message-ID: <CALpM8gR9h5YdQW_QCfxG8UxX-ZygoNv6ySgYot0fX2DSRpOJig@mail.gmail.com>
References: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
	<e25beb09-f4b0-899b-134a-c30d81d74926@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0170433215130962145=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e25beb09-f4b0-899b-134a-c30d81d74926@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============0170433215130962145==
Content-Type: multipart/alternative; boundary=001a114203d61d6fa3054b70c564

--001a114203d61d6fa3054b70c564
Content-Type: text/plain; charset=UTF-8

I appreciate the insight. Are there any plans to enhance the code to allow
more parallel execution and/or allow users to experiment with QD?

Thanks, again.
Mike

On Thu, Mar 23, 2017 at 7:02 PM, Heinz Mauelshagen <heinzm@redhat.com>
wrote:

>
>
> On 03/23/2017 05:35 PM, Michael McCarthy wrote:
>
> Hello, collective wisdom,
>
> I'm new to the list and apologize if this is not the right place to ask
> this type of question and if so, would be glad receive pointers to the
> correct one.
>
> Now the question:
>
> I'm looking for ways to improve snapshot-merge target performance. We're
> using CentOS 7.3 here. Both, the snapshot-origin and the snapshot (cow data
> holder) reside on NVMe SSDs. What we've seen in our tests is that the speed
> of the merge isn't approaching neither the throughput nor the IOPS limits
> of the NVMe devices. I suspect it might be because the merge operation is
> single threaded and uses QD of 1.
>
>
> Yes, that's practically what it is.
>
> Snapshot merge is based on dm-kcopyd (device-mapper kernel copy daemon).
>
> The merge performs copies from the snapshots exception store to the origin
> LV sequentially.
> In each step It maximizes the payload per copy in case it identifies
> sequential origin chunks
> in consecutive entries in the snapshot exception store.
>
> The success of this optimization depends on previous update patterns on
> snapshot and origin:
> - the more sequential update patterns occured the better
> - with random update patterns the paylod per copy will drop to snapshot
> chunk_size worst case
>
> There's no knob to tweak this.
> The "snapshot-merge" target would need to be enhanced.
>
> Heinz
>
>
> Could anyone with enough knowledge about the DM code shed some light on
> how it operates during the merge? Are there any interfaces to improve the
> speed of this operation without altering the code?
>
> Thanks,
> Mike
>
>
> --
> dm-devel mailing listdm-devel@redhat.comhttps://www.redhat.com/mailman/listinfo/dm-devel
>
>
>

--001a114203d61d6fa3054b70c564
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:12.800000190734863px">I appreciat=
e the insight. Are there any plans to enhance the code to allow more parall=
el execution and/or allow users to experiment with QD?</span><div style=3D"=
font-size:12.800000190734863px"><br></div><div style=3D"font-size:12.800000=
190734863px">Thanks, again.</div><div style=3D"font-size:12.800000190734863=
px">Mike</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quot=
e">On Thu, Mar 23, 2017 at 7:02 PM, Heinz Mauelshagen <span dir=3D"ltr">&lt=
;<a href=3D"mailto:heinzm@redhat.com" target=3D"_blank">heinzm@redhat.com</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
 =20
   =20
 =20
  <div bgcolor=3D"#FFFFFF" text=3D"#000000"><span class=3D"">
    <p><br>
    </p>
    <br>
    <div class=3D"m_996897766156133191moz-cite-prefix">On 03/23/2017 05:35 =
PM, Michael
      McCarthy wrote:<br>
    </div>
    <blockquote type=3D"cite">
      <div dir=3D"ltr">Hello, collective wisdom,
        <div><br>
        </div>
        <div>I&#39;m new to the list and apologize if this is not the right
          place to ask this type of question and if so, would be glad
          receive pointers to the correct one.</div>
        <div><br>
        </div>
        <div>Now the question:</div>
        <div><br>
        </div>
        <div>I&#39;m looking for ways to improve snapshot-merge target
          performance. We&#39;re using=C2=A0CentOS 7.3 here. Both, the
          snapshot-origin and the snapshot (cow data holder) reside on
          NVMe SSDs. What we&#39;ve seen in our tests is that the speed of
          the merge isn&#39;t approaching neither the throughput nor the
          IOPS limits of the NVMe devices. I suspect it might be because
          the merge operation is single threaded and uses QD of 1.</div>
      </div>
    </blockquote>
    <br></span>
    Yes, that&#39;s practically what it is.<br>
    <br>
    Snapshot merge is based on dm-kcopyd (device-mapper kernel copy
    daemon).<br>
    <br>
    The merge performs copies from the snapshots exception store to the
    origin LV sequentially.<br>
    In each step It maximizes the payload per copy in case it identifies
    sequential origin chunks<br>
    in consecutive entries in the snapshot exception store.<br>
    <br>
    The success of this optimization depends on previous update patterns
    on snapshot and origin:<br>
    - the more sequential update patterns occured the better<br>
    - with random update patterns the paylod per copy will drop to
    snapshot chunk_size worst case<br>
    <br>
    There&#39;s no knob to tweak this.<br>
    The &quot;snapshot-merge&quot; target would need to be enhanced.<br>
    <br>
    Heinz<br>
    <br>
    <blockquote type=3D"cite"><span class=3D"">
      <div dir=3D"ltr">
        <div>=C2=A0</div>
        <div>Could anyone with enough knowledge about the DM code shed
          some light on how it operates during the merge? Are there any
          interfaces to improve the speed of this operation without
          altering the code?<br>
        </div>
        <div><br>
        </div>
        <div>Thanks,</div>
        <div>Mike</div>
      </div>
      <br>
      <fieldset class=3D"m_996897766156133191mimeAttachmentHeader"></fields=
et>
      <br>
      </span><span class=3D"HOEnZb"><font color=3D"#888888"><pre>--
dm-devel mailing list
<a class=3D"m_996897766156133191moz-txt-link-abbreviated" href=3D"mailto:dm=
-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a>
<a class=3D"m_996897766156133191moz-txt-link-freetext" href=3D"https://www.=
redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.=
com/<wbr>mailman/listinfo/dm-devel</a></pre>
    </font></span></blockquote>
    <br>
  </div>

</blockquote></div><br></div>

--001a114203d61d6fa3054b70c564--


--===============0170433215130962145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0170433215130962145==--
