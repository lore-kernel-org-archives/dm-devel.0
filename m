Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E247EE57EF
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 10:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694170275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=NXQRQd2pe2CPR9XKV/q3tS41XkKMrWxlsKAJmOywSDc=;
	b=J1XHjMo7VmxOoHTIrUyfFuXnv0bQisfmL/55voPZ/a0OzOqZ6r3bW0W6W0Z/wxVmZweYbq
	AWOT02R5I0/GJr7Xslbz72OnmHi/qOygelN02vuQgig6ebi/aebZ6bTt6JY+vEr1Lc+0tl
	ByOtfRhiBRnGa13QxlDNYaF/EiC5Z/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-MSmNQwyYNii5xNtYfk3cLw-1; Fri, 08 Sep 2023 06:51:09 -0400
X-MC-Unique: MSmNQwyYNii5xNtYfk3cLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37E4A84AF9D;
	Fri,  8 Sep 2023 10:51:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD5D21460FE5;
	Fri,  8 Sep 2023 10:51:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 98502194658F;
	Fri,  8 Sep 2023 10:51:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8AF34194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 10:51:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 675F1412F2D6; Fri,  8 Sep 2023 10:51:05 +0000 (UTC)
Received: from [10.43.17.103] (unknown [10.43.17.103])
 by smtp.corp.redhat.com (Postfix) with ESMTP id F4185412F2D3;
 Fri,  8 Sep 2023 10:51:03 +0000 (UTC)
Message-ID: <15c62097-d58f-4e66-bdf5-e0edb1306b2f@redhat.com>
Date: Fri, 8 Sep 2023 12:51:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jan Kara <jack@suse.cz>
References: <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
 <20230908073244.wyriwwxahd3im2rw@quack3>
 <86235d7a-a7ea-49da-968e-c5810cbf4a7b@redhat.com>
 <20230908102014.xgtcf5wth2l2cwup@quack3>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <20230908102014.xgtcf5wth2l2cwup@quack3>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: multipart/mixed; boundary="===============2778738219296978540=="

This is a multi-part message in MIME format.
--===============2778738219296978540==
Content-Type: multipart/alternative;
 boundary="------------Fs3zmNrVDuUvz31kOW1lPyK9"
Content-Language: en-US, cs

This is a multi-part message in MIME format.
--------------Fs3zmNrVDuUvz31kOW1lPyK9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 08. 09. 23 v 12:20 Jan Kara napsal(a):
> On Fri 08-09-23 11:29:40, Zdenek Kabelac wrote:
>> Dne 08. 09. 23 v 9:32 Jan Kara napsal(a):
>>> On Thu 07-09-23 14:04:51, Mikulas Patocka wrote:
>>>> On Thu, 7 Sep 2023, Christian Brauner wrote:
>>>>
>>>>>> I think we've got too deep down into "how to fix things" but I'm not 100%
>>>>> We did.
>>>>>
>>>>>> sure what the "bug" actually is. In the initial posting Mikulas writes "the
>>>>>> kernel writes to the filesystem after unmount successfully returned" - is
>>>>>> that really such a big issue?
>>>> I think it's an issue if the administrator writes a script that unmounts a
>>>> filesystem and then copies the underyling block device somewhere. Or a
>>>> script that unmounts a filesystem and runs fsck afterwards. Or a script
>>>> that unmounts a filesystem and runs mkfs on the same block device.
>>> Well, e.g. e2fsprogs use O_EXCL open so they will detect that the filesystem
>>> hasn't been unmounted properly and complain. Which is exactly what should
>>> IMHO happen.
>> I'd likely propose in this particular state of unmounting of a frozen
>> filesystem to just proceed - and drop the frozen state together with release
>> filesystem and never issue any ioctl from such filelsystem to the device
>> below - so it would not be a 100% valid unmount - but since the freeze
>> should be nearly equivalent of having a proper 'unmount' being done -  it
>> shoudn't be causing any harm either - and  all resources associated could
>> be 'released.  IMHO it's correct to 'drop' frozen state for filesystem
>> that is not going to exist anymore  (assuming it's the last  such user)
> This option was also discussed in the past and it has nasty consequences as
> well. Cleanly shutting down a filesystem usually needs to write to the
> underlying device so either you allow the filesystem to write to the device
> on umount breaking assumptions of the user who froze the fs or you'd have
> to implement a special handling for this case for every filesystem to avoid
> the writes (and put up with the fact that the filesystem will appear as
> uncleanly shutdown on the next mount). Not particularly nice either...


I'd say there are several options and we should aim towards the variant which 
is most usable by normal users.

Making hyper complex  unmount rule logic that basically no user-space tools 
around Gnome/KDE... are able to handle well and getting it to the position 
where only the core kernel developer have all the 'wisdom' to detect and 
decode system state and then 'know what's going on'  isn't the favourite goal 
here.

Freeze should be getting the filesystem into 'consistent' state - filesystem 
should  be able to 'easily' recover and finish all the ongoing  'unfinished' 
process with the next mount without requiring full 'fsck' - otherwise it would 
be useless for i.e. snapshot.

So to me this looks like the win-win strategy where we basically do not loose 
any information  and we also do not leak kernel resources - since i..e in case 
of DM devices - the underlying DM device might have already changed  disk 
characteristics anyway.

If the developers then believe - that 'more variants' of complex behavior are 
necessary - then kernel could have some  sysfs parameter to configure some 
'more advanced' logic  i.e.  keep  'fs mounted'   for those skilled admins who 
are able to go through the deepest corners  here  -  but other then that  
plain 'umount' should really go with the meaning of   a)   manages to umount 
and release a device    b)  in other case reports to a user there is still 
something holding device....

Regards


Zdenek


--------------Fs3zmNrVDuUvz31kOW1lPyK9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">Dne 08. 09. 23 v 12:20 Jan Kara
      napsal(a):<br>
    </div>
    <blockquote type="cite"
      cite="mid:20230908102014.xgtcf5wth2l2cwup@quack3">
      <pre class="moz-quote-pre" wrap="">On Fri 08-09-23 11:29:40, Zdenek Kabelac wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Dne 08. 09. 23 v 9:32 Jan Kara napsal(a):
</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">On Thu 07-09-23 14:04:51, Mikulas Patocka wrote:
</pre>
          <blockquote type="cite">
            <pre class="moz-quote-pre" wrap="">
On Thu, 7 Sep 2023, Christian Brauner wrote:

</pre>
            <blockquote type="cite">
              <blockquote type="cite">
                <pre class="moz-quote-pre" wrap="">I think we've got too deep down into "how to fix things" but I'm not 100%
</pre>
              </blockquote>
              <pre class="moz-quote-pre" wrap="">We did.

</pre>
              <blockquote type="cite">
                <pre class="moz-quote-pre" wrap="">sure what the "bug" actually is. In the initial posting Mikulas writes "the
kernel writes to the filesystem after unmount successfully returned" - is
that really such a big issue?
</pre>
              </blockquote>
            </blockquote>
            <pre class="moz-quote-pre" wrap="">I think it's an issue if the administrator writes a script that unmounts a
filesystem and then copies the underyling block device somewhere. Or a
script that unmounts a filesystem and runs fsck afterwards. Or a script
that unmounts a filesystem and runs mkfs on the same block device.
</pre>
          </blockquote>
          <pre class="moz-quote-pre" wrap="">Well, e.g. e2fsprogs use O_EXCL open so they will detect that the filesystem
hasn't been unmounted properly and complain. Which is exactly what should
IMHO happen.
</pre>
        </blockquote>
      </blockquote>
    </blockquote>
    <span style="white-space: pre-wrap">
</span>
    <blockquote type="cite"
      cite="mid:20230908102014.xgtcf5wth2l2cwup@quack3">
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">I'd likely propose in this particular state of unmounting of a frozen
filesystem to just proceed - and drop the frozen state together with release
filesystem and never issue any ioctl from such filelsystem to the device
below - so it would not be a 100% valid unmount - but since the freeze
should be nearly equivalent of having a proper 'unmount' being done -  it
shoudn't be causing any harm either - and  all resources associated could 
be 'released.  IMHO it's correct to 'drop' frozen state for filesystem
that is not going to exist anymore  (assuming it's the last  such user)
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
This option was also discussed in the past and it has nasty consequences as
well. Cleanly shutting down a filesystem usually needs to write to the
underlying device so either you allow the filesystem to write to the device
on umount breaking assumptions of the user who froze the fs or you'd have
to implement a special handling for this case for every filesystem to avoid
the writes (and put up with the fact that the filesystem will appear as
uncleanly shutdown on the next mount). Not particularly nice either...
</pre>
    </blockquote>
    <p><br>
    </p>
    <p>I'd say there are several options and we should aim towards the
      variant which is most usable by normal users.</p>
    <p>Making hyper complex  unmount rule logic that basically no
      user-space tools around Gnome/KDE... are able to handle well and
      getting it to the position where only the core kernel developer
      have all the 'wisdom' to detect and decode system state and then
      'know what's going on'  isn't the favourite goal here.</p>
    <p>Freeze should be getting the filesystem into 'consistent' state 
      - filesystem should  be able to 'easily' recover and finish all
      the ongoing  'unfinished' process with the next mount without
      requiring full 'fsck' - otherwise it would be useless for i.e.
      snapshot.</p>
    <p>So to me this looks like the win-win strategy where we basically
      do not loose any information  and we also do not leak kernel
      resources - since i..e in case of DM devices - the underlying DM
      device might have already changed  disk characteristics anyway.</p>
    <p>If the developers then believe - that 'more variants' of complex
      behavior are necessary - then kernel could have some  sysfs
      parameter to configure some 'more advanced' logic  i.e.  keep  'fs
      mounted'   for those skilled admins who are able to go through the
      deepest corners  here  -  but other then that  plain 'umount'
      should really go with the meaning of   a)   manages to umount and
      release a device    b)  in other case reports to a user there is
      still something holding device....  <br>
    </p>
    <p>Regards</p>
    <p><br>
    </p>
    <p>Zdenek<br>
    </p>
    <p><br>
    </p>
  </body>
</html>

--------------Fs3zmNrVDuUvz31kOW1lPyK9--

--===============2778738219296978540==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2778738219296978540==--

