From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Thu, 22 May 2008 14:00:12 +0200
Message-ID: <4835604C.30107@linpro.no>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz><18484.2693.62883.535755@notabene.brown>	<ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com><ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no><ABFD05FF09D13E4883B757E75603624D011E95FF@ex-sea1.vistocorp.com>	<48348DA8.2010803@linpro.no>	<ABFD05FF09D13E4883B757E75603624D011E960A@ex-sea1.vistocorp.com>
	<ABFD05FF09D13E4883B757E75603624D011E961E@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E961E@ex-sea1.vistocorp.com>
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
Cc: Michael Denney <mdenney@visto.com>, Geoff Quan <GQuan@visto.com>, Kevin Koplar <kevin.koplar@hds.com>
List-Id: dm-devel.ids

* Craig Simpson

> All is Beautiful now. Not logging any errors to messages so looks like "
> mpath_prio_hds_modular" is getting called correctly. 
> 
> Multipath -ll
> asm14 (1HITACHI_730600240013) dm-55 HITACHI,DF600F
> [size=64G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=2][active]
>  \_ 1:0:0:13 sdcp 69:208  [active][ready]
>  \_ 0:0:0:13 sdn  8:208   [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 0:0:1:13 sdbb 67:80   [active][ready]
>  \_ 1:0:1:13 sded 128:80  [active][ready]

Yes, you can see from this output that sdcp and sdn have a prio of 1,
placing them in the same priority group (which in sum have a prio of 2),
so the prio-callout definitely works as it is supposed to.  Everything
looks good, now you should try yanking some fibres (with lots of I/O
activity running) to make sure that it actually is able to handle a
failure scenario.  Good luck.

Regards,
-- 
Tore Anderson
