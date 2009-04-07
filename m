From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: How does the multipath driver handle the order of I/O
Date: Tue, 7 Apr 2009 14:33:50 +0800
Message-ID: <d364733c0904062333n523abdc7n271609254773e96b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,
I looked througth the mail "Barriers still not passing on simple dm
devices". It seems that the dm multipath driver could not guarantee
the order of I/Os. But as far as I know, other dmp driver such as
Veritas dmp driver could handle this. How could other dmp driver
handle this since there is some limitation in block layer?

Thanks

-- 
Xie Gang
