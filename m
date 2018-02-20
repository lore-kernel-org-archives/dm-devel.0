From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Device mapper for temporarily buffering writes on
 fast device before pushing to slower device
Date: Tue, 20 Feb 2018 13:58:40 +0100
Message-ID: <7e826e29-ed12-ef6a-ffbf-7ade8b27eda1@redhat.com>
References: <CAN-y+EJLroxotABwM=5BqFH1byDmLExi7n0o0FTv9KNWFVAzaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2564487814351337081=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAN-y+EJLroxotABwM=5BqFH1byDmLExi7n0o0FTv9KNWFVAzaQ@mail.gmail.com>
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
To: Drew Hastings <dhastings@crucialwebhost.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============2564487814351337081==
Content-Type: multipart/alternative;
	boundary="------------FC07E8D51371066A82181CAF"
Content-Language: de-CH

This is a multi-part message in MIME format.
--------------FC07E8D51371066A82181CAF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

dm-writecache (see list archieve) is what you're looking for.


On 02/19/2018 09:47 PM, Drew Hastings wrote:
> I found stochastic multi-queue and writeboost to be insufficient for 
> this purpose. I'm wondering if anything exists that fits this 
> description:
>
> Device mapper creates a "cache" device on a fast device (SSD/NVME, 
> etc)... and writes to the device *always* hit the fast device. Writes 
> are later flushed to the slower device as fast as the slow device can 
> handle them.
>
> The problem with the caching solutions I have found with device mapper 
> is that they require the block to be identified as "hot" first, even 
> when the cache itself is not 100% utilized. Read performance is 
> largely irrelevant.
>
> Is there a device mapper implementation that works in this fashion; 
> where 100% of writes happen to the fast device? I was thinking COW 
> effectively does this, but the problem is it does not 
> automatically/periodically flush writes, you have to do them all at once.
>
> I had seen some conversations about trying to get the multiqueue (mq, 
> not smq) policy to do this with zero values for thresholds, but it did 
> not seem like any were successful in ensuring the first write would 
> hit the fast device.
>
> Thanks!
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------FC07E8D51371066A82181CAF
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>dm-writecache (see list archieve) is what you're looking for.<br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 02/19/2018 09:47 PM, Drew Hastings
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAN-y+EJLroxotABwM=5BqFH1byDmLExi7n0o0FTv9KNWFVAzaQ@mail.gmail.com">
      <div dir="ltr">I found stochastic multi-queue and writeboost to be
        insufficient for this purpose. I'm wondering if anything exists
        that fits this description:
        <div><br>
        </div>
        <div>Device mapper creates a "cache" device on a fast device
          (SSD/NVME, etc)... and writes to the device *always* hit the
          fast device. Writes are later flushed to the slower device as
          fast as the slow device can handle them.</div>
        <div><br>
        </div>
        <div>The problem with the caching solutions I have found with
          device mapper is that they require the block to be identified
          as "hot" first, even when the cache itself is not 100%
          utilized. Read performance is largely irrelevant.</div>
        <div><br>
        </div>
        <div>Is there a device mapper implementation that works in this
          fashion; where 100% of writes happen to the fast device? I was
          thinking COW effectively does this, but the problem is it does
          not automatically/periodically flush writes, you have to do
          them all at once.</div>
        <div><br>
        </div>
        <div>I had seen some conversations about trying to get
          the multiqueue (mq, not smq) policy to do this with zero
          values for thresholds, but it did not seem like any were
          successful in ensuring the first write would hit the fast
          device.</div>
        <div><br>
        </div>
        <div>Thanks!</div>
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

--------------FC07E8D51371066A82181CAF--


--===============2564487814351337081==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2564487814351337081==--
