From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 13:48:39 +0200
Message-ID: <427e4283-7ea2-f394-b463-89c9c6bd0a23@redhat.com>
References: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3757554013993548848=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
Content-Language: en-MW
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkangksu@gmail.com>, "dm-devel@redhat.com >> device-mapper development" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============3757554013993548848==
Content-Type: multipart/alternative;
	boundary="------------EBD7BA665D4F9081EF149855"
Content-Language: en-MW

This is a multi-part message in MIME format.
--------------EBD7BA665D4F9081EF149855
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Özkan,

as you report, your device-mapper version is too recent for your kernel
(the major version has to match and the kernel minor version needs to 
greater or equal),
i.e. 4.39 is too recent for version 4.37 in the kernel.

In case you updated kernel and userspace by pacman means, something's 
broken in the Arch repositories.

You either have to downgrade your device-mapper userspace
or upgrade your kernel accordingly.

Heinz


On 09/19/2018 12:35 PM, Özkan Göksu wrote:
> Hello.
> I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1 
> | multipath-tools 0.7.7-1
> After that multipathd started to giving the log: // device-mapper: 
> ioctl: ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)
> It was working great on my ex kernel "4.14.30-1-lts" with | 
> device-mapper 2.02.177-5 | multipath-tools 0.7.6-1
> Also I tried multipath git version but nothing change.
>
> I think the problem related to device-mapper and my device mapper 
> Build Date: 2018-08-01 19:05 UTC = 
> https://www.archlinux.org/packages/core/x86_64/device-mapper/
> Do I need to compile device mapper git version or what should I do?
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------EBD7BA665D4F9081EF149855
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>Özkan,<br>
    </p>
    <p>as you report, your device-mapper version is too recent for your
      kernel<br>
      (the major version has to match and the kernel minor version needs
      to greater or equal),<br>
      i.e. 4.39 is too recent for version 4.37 in the kernel.</p>
    <p>In case you updated kernel and userspace by pacman means,
      something's broken in the Arch repositories.<br>
    </p>
    <p>You either have to downgrade your device-mapper userspace<br>
      or upgrade your kernel accordingly.<br>
      <br>
      Heinz<br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 09/19/2018 12:35 PM, Özkan Göksu
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com">
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <div dir="ltr">
        <div dir="ltr">
          <div dir="ltr">
            <div dir="ltr">
              <div class="gmail-linestyle1 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px">Hello.
                <br>
                <span style="font-size:12.8px">I just upgraded my Kernel
                  to: 4.14.70-1-lts | device-mapper 2.02.181-1 |
                  multipath-tools 0.7.7-1</span><br>
              </div>
              <div class="gmail-linestyle2 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px"><span
                  style="font-size:12.8px">After that multipathd started
                  to giving the log: </span><span
                  style="font-size:12.8px">// device-mapper: ioctl:
                  ioctl interface mismatch: kernel(4.37.0),
                  user(4.39.0), cmd(16)</span><br>
              </div>
              <div class="gmail-linestyle2 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px"><span
                  style="font-size:12.8px">It was working great on my ex
                  kernel "4.14.30-1-lts" with | device-mapper 2.02.177-5
                  | multipath-tools 0.7.6-1</span><br>
              </div>
              <div class="gmail-linestyle2 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px"><span
                  style="font-size:12.8px">Also I tried multipath git
                  version but nothing change.</span><br>
              </div>
              <div class="gmail-linestyle1 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px"><br>
              </div>
              <div class="gmail-linestyle1 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px">I
                think the problem related to device-mapper and my device
                mapper Build Date: 2018-08-01 19:05 UTC = <a
                  href="https://www.archlinux.org/packages/core/x86_64/device-mapper/"
                  target="_blank" rel="noopener" moz-do-not-send="true">https://www.archlinux.org/packages/core/x86_64/device-mapper/</a></div>
              <div class="gmail-linestyle2 gmail-colourline"
                style="font-family:Consolas,&quot;Lucida
Console&quot;,monospace;padding-left:7px;word-wrap:break-word;color:rgb(0,0,0);font-size:12.8px">Do
                I need to compile device mapper git version or what
                should I do?</div>
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

--------------EBD7BA665D4F9081EF149855--


--===============3757554013993548848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3757554013993548848==--
