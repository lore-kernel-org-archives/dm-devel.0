From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Delay/Sleep in .pg_init
Date: Wed, 28 May 2008 11:11:47 -0700
Message-ID: <110b17190805281111p61df99bgb575e47a04c7f66d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi All,

I am using the code written by Hannes for supporting explicit mode ALUA.
Our controllers sometimes takes about 4-5 seconds for the transition
in failover/failback.
So I want to introduce a delay of say 5 seconds in the .pg_init
function to buy some time.

Is this a good idea? I tried using some sleep method but it would hang the OS.
What else can be done?

Regards,
Pradipmaya.
