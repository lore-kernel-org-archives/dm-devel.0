From: =?ISO-8859-1?Q?Ralf_Aum=FCller?= <Ralf.Aumueller@informatik.uni-stuttgart.de>
Subject: Question about dm-multipath and Sun StorageTek 6140
Date: Fri, 09 Feb 2007 10:56:16 +0100
Message-ID: <45CC4540.7020707@informatik.uni-stuttgart.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hallo,

I have the following questions about dm-multipathing:

- is it true that I need a hardware-specific handler for arrays running
  with active/passive controllers (like the Sun StorageTek 6140) to
  get the the LUN trespassing working?

- did someone get the Sun StorageTek 6140 configured for dm-multipath?
  (so that the LUN trespassing works)

Thank's in advance,

Ralf

(I a also asked these question on the RHEL-list but didn't get an answer
so I try it here again)
