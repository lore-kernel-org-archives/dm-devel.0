From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Question about merge performance
Date: Fri, 24 Mar 2017 14:40:04 +0100
Message-ID: <6c0efb4f-3f47-cf41-dbd0-0cd0129bcc00@redhat.com>
References: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7936097893335871574=="
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
--===============7936097893335871574==
Content-Type: multipart/alternative;
	boundary="------------CAD17A92A2EC4DE5A9608C9D"

This is a multi-part message in MIME format.
--------------CAD17A92A2EC4DE5A9608C9D
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

Yes, that's what it does.

Using dm-kcopyd snapshot merging submits payloads to be copied across to 
the origin
sequentially aiming to maximize individual payloads by identifying any 
consecutive exception
store chunks which are in origin adress order.

If your update patters to the snapshot have been sequential that 
optimization will help througput,
if those were random it doesn't and the payloads will be snapshot chunks 
in size.

There's no knob to tune this (but io scheduler which don't help with 
your NVMe storage)

The "snapshot-merge" target would need to be enhanced to provide better 
throughput.

Regards,
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


--------------CAD17A92A2EC4DE5A9608C9D
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 03/23/2017 05:35 PM, Michael McCarthy wrote:<br>
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
    Yes, that's what it does.<br>
    <br>
    Using dm-kcopyd snapshot merging submits payloads to be copied
    across to the origin<br>
    sequentially aiming to maximize individual payloads by identifying
    any consecutive exception<br>
    store chunks which are in origin adress order.<br>
    <br>
    If your update patters to the snapshot have been sequential that
    optimization will help througput,<br>
    if those were random it doesn't and the payloads will be snapshot
    chunks in size.<br>
    <br>
    There's no knob to tune this (but io scheduler which don't help with
    your NVMe storage)<br>
    <br>
    The "snapshot-merge" target would need to be enhanced to provide
    better throughput.<br>
    <br>
    Regards,<br>
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

--------------CAD17A92A2EC4DE5A9608C9D--


--===============7936097893335871574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7936097893335871574==--
