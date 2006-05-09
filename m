From: Brad Dameron <brad@seatab.com>
Subject: Multipath load balancing?
Date: Tue, 09 May 2006 15:07:44 -0700
Message-ID: <1147212464.13567.2.camel@serpent.office.seatab.com>
References: <1147130744.29855.1.camel@serpent.office.seatab.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147130744.29855.1.camel@serpent.office.seatab.com>
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

I am rewriting this since I received no answer.

Does DM and Multipath tools now offer load balancing between 2 HBA ports
to a single SAN? So if I have a 2 port HBA that can both see the same
LUN I can setup a multipath device and it will then utilize both paths
as one larger single path?

Thanks,
Brad Dameron
SeaTab Software
www.seatab.com
