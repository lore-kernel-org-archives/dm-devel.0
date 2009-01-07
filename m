From: "lu ping" <luping.nju@gmail.com>
Subject: why "real" device and "snapshot-origin" differs after a
	snapshot is created
Date: Tue, 6 Jan 2009 20:14:19 -0800
Message-ID: <e80b0eb70901062014t33172e81lfeb8f7b0f2caf2e1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1015151741=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1015151741==
Content-Type: multipart/alternative;
	boundary="----=_Part_45110_9030694.1231301659682"

------=_Part_45110_9030694.1231301659682
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Folks,

I am a dm newbie and I am not sure if it's the right place to ask my
question. But I couldn't find any other related mail list...

After I create a LVM snapshot, there are four related devices. According to
the documentation, there is a "real" device which contains the original
mapping table of the source, while a "snapshot-origin" device gets the
original device number.

As to my understanding, when you read from "snapshot-origin", it will just
pass the read to the "real" device, while when you write to it, it does the
COW to the "COW device" and then again pass the writes to the "real" device.
But after I wrote to "snapshot-origin", I found it's content no longer the
same as the "real" device (from a "diff"). I must be missing something
important here. Can somebody explain to me why?

Thanks
Ping

------=_Part_45110_9030694.1231301659682
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Folks,<br><br>I am a dm newbie and I am not sure if it&#39;s the right place to ask my question. But I couldn&#39;t find any other related mail list...<br><br>After I create a LVM snapshot, there are four related devices. According to the documentation, there is a &quot;real&quot; device which contains the original mapping table of the source, while a &quot;snapshot-origin&quot; device gets the original device number.<br>
<br>As to my understanding, when you read from &quot;snapshot-origin&quot;, it will just pass the read to the &quot;real&quot; device, while when you write to it, it does the COW to the &quot;COW device&quot; and then again pass the writes to the &quot;real&quot; device.<br>
But after I wrote to &quot;snapshot-origin&quot;, I found it&#39;s content no longer the same as the &quot;real&quot; device (from a &quot;diff&quot;). I must be missing something important here. Can somebody explain to me why?<br>
<br>Thanks<br>Ping<br>

------=_Part_45110_9030694.1231301659682--


--===============1015151741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1015151741==--
