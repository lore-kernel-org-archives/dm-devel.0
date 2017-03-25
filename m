From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Question about merge performance
Date: Sat, 25 Mar 2017 02:52:33 +0100
Message-ID: <9b2abc91-549b-f235-84bd-2dfe5a8092f6@redhat.com>
References: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2987257498133520214=="
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
--===============2987257498133520214==
Content-Type: multipart/alternative;
	boundary="------------A77837F4C480217774BB5E02"

This is a multi-part message in MIME format.
--------------A77837F4C480217774BB5E02
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

Yes, that's what it is.

Using dm-kcopyd the snapshot merge sequentially copies exception store 
chunks across to the origin.

Though it aims to copy consecutive chunks across, the success of that 
optimization depends on
sequential write patterns to the origin and the snapshot populating the 
exception store.
In case writes were random, one chunk will be transferred per copy worst 
case.

There's no knob to tune this (but io schedulers which ain't help with 
yur NVMe backends).

The "snaphsot-merge" target would need to be enhanced to provide higher 
throughput.

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


--------------A77837F4C480217774BB5E02
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
    Yes, that's what it is.<br>
    <br>
    Using dm-kcopyd the snapshot merge sequentially copies exception
    store chunks across to the origin.<br>
    <br>
    Though it aims to copy consecutive chunks across, the success of
    that optimization depends on<br>
    sequential write patterns to the origin and the snapshot populating
    the exception store.<br>
    In case writes were random, one chunk will be transferred per copy
    worst case.<br>
    <br>
    There's no knob to tune this (but io schedulers which ain't help
    with yur NVMe backends).<br>
    <br>
    The "snaphsot-merge" target would need to be enhanced to provide
    higher throughput.<br>
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

--------------A77837F4C480217774BB5E02--


--===============2987257498133520214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2987257498133520214==--
