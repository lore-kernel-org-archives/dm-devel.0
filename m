From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Size affects performance?
Date: Wed, 01 Aug 2007 18:32:06 -0400
Message-ID: <46B109E6.3000109@ce.jp.nec.com>
References: <OF4938AA3C.6B364A5A-ONC125732A.003345EF-C125732A.00338569@de.ibm.com>
	<E909CD7E-123F-43D6-BEBB-56D60AED11C9@mikl.as>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E909CD7E-123F-43D6-BEBB-56D60AED11C9@mikl.as>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, public@mikl.as
List-Id: dm-devel.ids

Andrew Miklas wrote:
> I've noticed that the size of a device seems to affect its performance.
> Is this expected behaviour?

The difference might be caused by internal block size,
which kernel optimizes depending on the device size alignment.
The smaller the block size, the larger the number of I/Os sent
to the device (when you read/write /dev/something).

So you might want to check the block size ("blockdev --getbsz")
and see if it's related to your case.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
