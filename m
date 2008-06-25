From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Can we have customized path_checker?
Date: Wed, 25 Jun 2008 16:02:05 -0700
Message-ID: <110b17190806251602h685f5a4vfc508b816f7cdb16@mail.gmail.com>
References: <110b17190806251539t5fcc712fj780dd4852d269447@mail.gmail.com>
	<1214433880.32521.3.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1214433880.32521.3.camel@chandra-ubuntu>
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
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks Chandra; I just wanted to give it a try.

Regards,
Pradipmaya.

On Wed, Jun 25, 2008 at 3:44 PM, Chandra Seetharaman
<sekharan@us.ibm.com> wrote:
>
> On Wed, 2008-06-25 at 15:39 -0700, Pradipmaya Maharana wrote:
>> Hi All,
>>
>> Under the multipath.conf, can we have the customized path checker?
>> Something like:
>>
>> path_checker    /sbin/my_path_checker /dev/%n
>>
>> Please comment.
>
> Technically, yes, you can. I do not about "support" after that point :)
>
> But, remember that if your storage does have other configuration info
> built in, you will be overwriting them all.
>
>>
>> Thanks and Regards,
>> Pradipmaya.
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
