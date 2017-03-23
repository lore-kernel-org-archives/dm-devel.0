From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Question about merge performance
Date: Fri, 24 Mar 2017 00:02:37 +0100
Message-ID: <e25beb09-f4b0-899b-134a-c30d81d74926@redhat.com>
References: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8941213880592978012=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael McCarthy <mccarthy197310@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============8941213880592978012==
Content-Type: multipart/alternative;
	boundary="------------BA2D4A5630993E18C9DE0668"

This is a multi-part message in MIME format.
--------------BA2D4A5630993E18C9DE0668
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 03/23/2017 05:35 PM, Michael McCarthy wrote:
> Hello, collective wisdom,
>
> I'm new to the list and apologize if this is not the right place to 
> ask this type of question and if so, would be glad receive pointers to 
> the correct one.
>
> Now the question:
>
> I'm looking for ways to improve snapshot-merge target performance. 
> We're using CentOS 7.3 here. Both, the snapshot-origin and the 
> snapshot (cow data holder) reside on NVMe SSDs. What we've seen in our 
> tests is that the speed of the merge isn't approaching neither the 
> throughput nor the IOPS limits of the NVMe devices. I suspect it might 
> be because the merge operation is single threaded and uses QD of 1.

Yes, that's practically what it is.

Snapshot merge is based on dm-kcopyd (device-mapper kernel copy daemon).

The merge performs copies from the snapshots exception store to the 
origin LV sequentially.
In each step It maximizes the payload per copy in case it identifies 
sequential origin chunks
in consecutive entries in the snapshot exception store.

The success of this optimization depends on previous update patterns on 
snapshot and origin:
- the more sequential update patterns occured the better
- with random update patterns the paylod per copy will drop to snapshot 
chunk_size worst case

There's no knob to tweak this.
The "snapshot-merge" target would need to be enhanced.

Heinz

> Could anyone with enough knowledge about the DM code shed some light 
> on how it operates during the merge? Are there any interfaces to 
> improve the speed of this operation without altering the code?
>
> Thanks,
> Mike
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------BA2D4A5630993E18C9DE0668
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <p><br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 03/23/2017 05:35 PM, Michael
      McCarthy wrote:<br>
    </div>
    <blockquote
cite="mid:CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com"
      type="cite">
      <div dir="ltr">Hello, collective wisdom,
        <div><br>
        </div>
        <div>I'm new to the list and apologize if this is not the right
          place to ask this type of question and if so, would be glad
          receive pointers to the correct one.</div>
        <div><br>
        </div>
        <div>Now the question:</div>
        <div><br>
        </div>
        <div>I'm looking for ways to improve snapshot-merge target
          performance. We're using CentOS 7.3 here. Both, the
          snapshot-origin and the snapshot (cow data holder) reside on
          NVMe SSDs. What we've seen in our tests is that the speed of
          the merge isn't approaching neither the throughput nor the
          IOPS limits of the NVMe devices. I suspect it might be because
          the merge operation is single threaded and uses QD of 1.</div>
      </div>
    </blockquote>
    <br>
    Yes, that's practically what it is.<br>
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
    There's no knob to tweak this.<br>
    The "snapshot-merge" target would need to be enhanced.<br>
    <br>
    Heinz<br>
    <br>
    <blockquote
cite="mid:CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com"
      type="cite">
      <div dir="ltr">
        <div> </div>
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
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
  </body>
</html>

--------------BA2D4A5630993E18C9DE0668--


--===============8941213880592978012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8941213880592978012==--
