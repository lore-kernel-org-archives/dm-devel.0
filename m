From: Spelic <spelic@shiftmail.org>
Subject: EPRD and TIER vs bcache
Date: Fri, 13 Jul 2012 21:44:51 +0200
Message-ID: <50007AB3.3080309@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello all dm developers
have you seen latest kernel projects by Mark Ruijter at www.lessfs.com? 
he has an write-only caching block device with barrier correctness 
(EPRD) and one tiered storage implementation (TIER, which also uses eprd 
inside afaiu). I have not tested this stuff personally but seems very 
interesting.
In particular, latest published benchmarks of TIER against BCACHE at 
lessfs.com show TIER winning by a significant margin (about 2x). This 
stroke me because I read that bcache might be introduced into the kernel 
soon. Might TIER be a better choice?
Regards
S.
