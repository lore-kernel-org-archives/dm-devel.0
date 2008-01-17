From: malahal@us.ibm.com
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 12:35:50 -0800
Message-ID: <20080117203550.GB7307@us.ibm.com>
References: <110b17190801171040h28736660m7d77c57ef40c316e@mail.gmail.com>
	<EEBC5C82F965344199BFA3E6047FE13302E8F0@SAUSEXMB2.amd.com>
	<110b17190801171228j78b97944ob6c71090d2f4403f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801171228j78b97944ob6c71090d2f4403f@mail.gmail.com>
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

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Run the following:
> 
> # chkconfig multipathd on
> # /etc/init.d/ multipath status

The second command actually is "/etc/init.d/multipathd status"
to get the status of the given rc script (multipathd in this case)

--Malahal.
