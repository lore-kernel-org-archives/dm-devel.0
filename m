From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: About the thin provision function @ kernel 3.2 or
 later.
Date: Mon, 16 Jan 2012 17:21:06 +0100
Message-ID: <4F144E72.9030604@redhat.com>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0867167246544835824=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
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

This is a multi-part message in MIME format.
--===============0867167246544835824==
Content-Type: multipart/alternative;
	boundary="------------040809060502060102040209"

This is a multi-part message in MIME format.
--------------040809060502060102040209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/16/2012 02:27 AM, Yukihito HARA wrote:
> Hi, I'm Yukihito, and interested in Linux system.

Hi.

>
> Recently days, I became happy to hear that Linux kernel start to 
> support thin-provisioning function.
> And not trying to how it work on latest kernel.
>
> According to the word "thin provisioning", I'm imaging that, I can get 
> larger space than actual disk size. This image is born from 
> thin-provisioning system working on VMWare series.

Thin provisioning iis a general design to save storage costs.

There's solutions in software and hardware in the market, including VMWare.
Higher range storage systems feature it.

> And can write the files until reach to the physical maximum. Once 
> reach to the physical maximum, I can't write any more files to that 
> volume, but I can write more files after add additional physical disks 
> to thin-pool.

Yes.

>
> I could create the pool according to the documents included in the 
> kernel source(Documentation/device-mapper/thin-provisioning.txt).
> But I'm not sure, it works as I expecting like above.
>
> So can you provide more detailed documentation about the 
> thin-provisioning, if you have?

Did you read Documentation/device-mapper/thin-provisioning.txt in the 
kernel source tree to use it yet?
It provides advice how to create thin-provisioned devices and snapshots 
(see dmsetup message examples).

> There're no documentation written in Japanese, so I'll also output 
> this communication to wiki or my twitter in Japanese. It helpful to 
> make your work more major among Japanese IT engineers. And you can get 
> more feedback if the challengers in Japan will be increased.
> The worst point of the current documentation is, it's not instruct 
> about how to use like above. Can't get image how to use this like 
> VMware system from that document.

Keep in mind that there'll be LVM2 support available later in distributions.
You can pull that code from the HEAD of the LVM2 upstream repository for 
testing purposes already (not meant for production use obviously).

>
> Sorry, this is my private testing, not for work. So I can't get much 
> time to this, but very interested in.

Thanks for trying it, we're interested in external feedback.

Regards,
Heinz

>
>
> I'm looking forward to your answer.
>
> Thank you.
> Yukihito.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
===============================================================
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       heinzm@redhat.com
===============================================================


--------------040809060502060102040209
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 01/16/2012 02:27 AM, Yukihito HARA wrote:
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite">Hi, I'm Yukihito, and interested in Linux system.<br>
    </blockquote>
    <br>
    Hi.<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite"><br>
      Recently days, I became happy to hear that Linux kernel start to
      support thin-provisioning function.<br>
      And not trying to how it work on latest kernel.<br>
      <br>
      According to the word "thin provisioning", I'm imaging that, I can
      get larger space than actual disk size. This image is born from
      thin-provisioning system working on VMWare series.<br>
    </blockquote>
    <br>
    Thin provisioning iis a general design to save storage costs.<br>
    <br>
    There's solutions in software and hardware in the market, including
    VMWare.<br>
    Higher range storage systems feature it.<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite">
      And can write the files until reach to the physical maximum. Once
      reach to the physical maximum, I can't write any more files to
      that volume, but I can write more files after add additional
      physical disks to thin-pool.<br>
    </blockquote>
    <br>
    Yes.<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite">
      <br>
      I could create the pool according to the documents included in the
      kernel source(Documentation/device-mapper/thin-provisioning.txt).<br>
      But I'm not sure, it works as I expecting like above.<br>
      <br>
      So can you provide more detailed documentation about the
      thin-provisioning, if you have?<br>
    </blockquote>
    <br>
    Did you read Documentation/device-mapper/thin-provisioning.txt in
    the kernel source tree to use it yet?<br>
    It provides advice how to create thin-provisioned devices and
    snapshots (see dmsetup message examples).<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite">
      There're no documentation written in Japanese, so I'll also output
      this communication to wiki or my twitter in Japanese. It helpful
      to make your work more major among Japanese IT engineers. And you
      can get more feedback if the challengers in Japan will be
      increased.<br>
      The worst point of the current documentation is, it's not instruct
      about how to use like above. Can't get image how to use this like
      VMware system from that document.<br>
    </blockquote>
    <br>
    Keep in mind that there'll be LVM2 support available later in
    distributions.<br>
    You can pull that code from the HEAD of the LVM2 upstream repository
    for testing purposes already (not meant for production use
    obviously).<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite"><br>
      Sorry, this is my private testing, not for work. So I can't get
      much time to this, but very interested in.<br>
    </blockquote>
    <br>
    Thanks for trying it, we're interested in external feedback.<br>
    <br>
    Regards,<br>
    Heinz<br>
    <br>
    <blockquote
cite="mid:CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com"
      type="cite">
      <br>
      <br>
      I'm looking forward to your answer.<br>
      <br>
      Thank you.<br>
      Yukihito.<br>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
    <pre class="moz-signature" cols="72">-- 
===============================================================
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       <a class="moz-txt-link-abbreviated" href="mailto:heinzm@redhat.com">heinzm@redhat.com</a>
===============================================================</pre>
  </body>
</html>

--------------040809060502060102040209--


--===============0867167246544835824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0867167246544835824==--
