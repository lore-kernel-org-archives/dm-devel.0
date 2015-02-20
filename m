From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Sat, 21 Feb 2015 00:25:53 +0900
Message-ID: <54E75201.9030202@gmail.com>
References: <54A508F7.1020207@gmail.com> <20150118000952.GB26160@kroah.com>
	<20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
	<20150220150614.GA4740@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6227052674167017309=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150220150614.GA4740@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ejt@redhat.com
Cc: Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============6227052674167017309==
Content-Type: multipart/alternative;
	boundary="------------060308040409000202050805"

This is a multi-part message in MIME format.
--------------060308040409000202050805
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx6-phx2.redhat.com id t1KFQ5Pi010377

Yes.

That's another consensus of the block-level log-structured caching
works that I've introduced in the previous post.

For example, NetApp's Mercury (2012) has the following sentence=20
indicating that
it also copy data to in-memory buffer and write it (called log chunk in
the paper but I call dm-writeboost's equivalent "RAM buffer") to cache=20
device
when it gets full.
```
Once a successful acknowledgment is received, an I/O command=92s data is
copied to an in-memory buffer, called a log chunk, and the command is
completed to the upper layer. The log chunk is written to the cache=20
device when full.
```

- Akira

On 2015/02/21 0:06, Joe Thornber wrote:
> On Fri, Feb 20, 2015 at 05:44:01PM +0900, Akira Hayakawa wrote:
>> I will wait for ack from dm maintainers.
> Are you still copying the contents of every bio to your own memory
> buffer before writing it to disk?
>
> - Joe


--------------060308040409000202050805
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx6-phx2.redhat.com id t1KFQ5Pi010377

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    Yes.<br>
    <br>
    That's another consensus of the block-level log-structured caching<br=
>
    works that I've introduced in the previous post.<br>
    <br>
    For example, NetApp's Mercury (2012) has the following sentence
    indicating that<br>
    it also copy data to in-memory buffer and write it (called log chunk
    in<br>
    the paper but I call dm-writeboost's equivalent "RAM buffer") to
    cache device<br>
    when it gets full.<br>
    ```<br>
    <meta charset=3D"utf-8">
    Once a
    successful acknowledgment is received, an I/O command=92s
    data is<br>
    copied to an in-memory buffer, called a log chunk, and
    the command is<br>
    completed to the upper layer. The log chunk is
    written to the cache device when full.<br>
    ```<br>
    <br>
    - Akira<br>
    <br>
    <div class=3D"moz-cite-prefix">On 2015/02/21 0:06, Joe Thornber wrote=
:<br>
    </div>
    <blockquote cite=3D"mid:20150220150614.GA4740@debian" type=3D"cite">
      <pre wrap=3D"">On Fri, Feb 20, 2015 at 05:44:01PM +0900, Akira Haya=
kawa wrote:
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">I will wait for ack from dm maintainers.
</pre>
      </blockquote>
      <pre wrap=3D"">
Are you still copying the contents of every bio to your own memory
buffer before writing it to disk?

- Joe
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------060308040409000202050805--


--===============6227052674167017309==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============6227052674167017309==--
