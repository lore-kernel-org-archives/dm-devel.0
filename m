From: "Sebastian Herbszt" <herbszt@gmx.de>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 23:16:56 +0200
Message-ID: <01d601c8bd1a$c5fd99b0$0201a8c0@zeug>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>	<4836798F.4060100@linpro.no><000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>
	<4836A075.9090008@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"; reply-type=original
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

From: "Tore Anderson"
> Unfortunately I have found no way to detect if an array is operating in
> ALUA or PNR mode and have dm-multipath automatically apply different
> device{} sections based on that.  I have some nodes that are connected
> to both my CX3 and an old CX200 (which doesn't support ALUA), and due to
> this I need to use PNR mode on the CX3 too, wich kinda sucks.  Time to
> get rid of the CX200 I guess.

The comment and code from libmultipath/prioritizers/emc.c

 if ( /* Effective initiator type */
      sense_buffer[27] != 0x03
  /*
   * Failover mode should be set to 1 (PNR failover mode)
   * or 4 (ALUA failover mode).
   */
  || (((sense_buffer[28] & 0x07) != 0x04) &&
      ((sense_buffer[28] & 0x07) != 0x06))
  /* Arraycommpath should be set to 1 */
  || (sense_buffer[30] & 0x04) != 0x04) {
  pp_emc_log(0, "path not correctly configured for failover");
 }

doesn't help with the detection part?

- Sebastian
