From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Help request: setting up /dev/zero using dm-crypt ...
Date: Wed, 7 Feb 2018 14:43:28 +0100
Message-ID: <2a26b3e6-df48-5b82-a719-cf0bf41b87c3@redhat.com>
References: <CABRTiaiJNVk-UXOVq6Qhah3sLRrjj1sb6KVWHNnVP1JbMUzx1w@mail.gmail.com>
	<129830fa-aa37-7de1-6670-76eeaed5a18d@gmail.com>
	<CABRTiaigM23mYm2dZEtPpwTUsm3RdmD0e3pCf+E6LAJsj2eNJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9116637758050053096=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABRTiaigM23mYm2dZEtPpwTUsm3RdmD0e3pCf+E6LAJsj2eNJQ@mail.gmail.com>
Content-Language: de-CH
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ravi Prakash Putchala <praks.putchala@gmail.com>, Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============9116637758050053096==
Content-Type: multipart/alternative;
	boundary="------------D81F3A68D8C7B29E81E60289"
Content-Language: de-CH

This is a multi-part message in MIME format.
--------------D81F3A68D8C7B29E81E60289
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 02/07/2018 09:50 AM, Ravi Prakash Putchala wrote:
> Thank you, Milan. Will try these.
>
>     If you need experiment over a memory device, use either ramdisk,
>     scsi_debug module to it.
>     Another alternative is to create dm-zero device and use plain
>     dm-crypt (not LUKS).
>
>
> create dm-zero device:  How do I do this? Sorry, I do not have much 
> expertise in Linux.


E.g. 10TiB "zero" mapped device (pick your name instead of 'z'):

dmsetup create z --table "0 $((10*1024*1024*1024*2)) zero"

Block device node for this is:

  /dev/mapper/z


See dmsetup(8) and device-mapper target documentation in kernel source,
for instance Documentaion/device-mapper/zero.txt.

Heinz

>
> Ravi
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------D81F3A68D8C7B29E81E60289
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    On 02/07/2018 09:50 AM, Ravi Prakash Putchala wrote:<br>
    <blockquote type="cite"
cite="mid:CABRTiaigM23mYm2dZEtPpwTUsm3RdmD0e3pCf+E6LAJsj2eNJQ@mail.gmail.com">
      <div dir="ltr">Thank you, Milan. Will try these.<br>
        <br>
        <div>
          <div class="gmail_extra">
            <div class="gmail_quote">
              <blockquote class="gmail_quote" style="margin:0px 0px 0px
                0.8ex;border-left:1px solid
                rgb(204,204,204);padding-left:1ex">
                If you need experiment over a memory device, use either
                ramdisk, scsi_debug module to it.<br>
                Another alternative is to create dm-zero device and use
                plain dm-crypt (not LUKS).<span class="gmail-HOEnZb"></span><br>
              </blockquote>
              <div><br>
                create dm-zero device:  How do I do this? Sorry, I do
                not have much expertise in Linux.<br>
              </div>
            </div>
          </div>
        </div>
      </div>
    </blockquote>
    <br>
    <br>
    E.g. 10TiB "zero" mapped device (pick your name instead of 'z'):<br>
    <br>
    dmsetup create z --table "0 $((10*1024*1024*1024*2)) zero"<br>
    <br>
    Block device node for this is:<br>
    <br>
     /dev/mapper/z<br>
    <br>
    <br>
    See dmsetup(8) and device-mapper target documentation in kernel
    source,<br>
    for instance Documentaion/device-mapper/zero.txt.<br>
    <br>
    Heinz<br>
    <br>
    <blockquote type="cite"
cite="mid:CABRTiaigM23mYm2dZEtPpwTUsm3RdmD0e3pCf+E6LAJsj2eNJQ@mail.gmail.com">
      <div dir="ltr">
        <div>
          <div class="gmail_extra">
            <div class="gmail_quote">
              <div><br>
              </div>
              <div>Ravi<br>
              </div>
            </div>
          </div>
        </div>
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

--------------D81F3A68D8C7B29E81E60289--


--===============9116637758050053096==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9116637758050053096==--
