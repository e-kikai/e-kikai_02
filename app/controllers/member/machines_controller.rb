class Member::MachinesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_company

  def index
    @machines = @company.machines
  end

  def new
    @machines = @company.machines.new
  end

  def create
    @machine = @company.machines.new(machine_params)
    if @machine.save
      redirect_to member_machines_path, notice: '登録しました'
    else
      render :new
    end
  end

  def edit
    @machine = @company.machines.find(params[:id])
  end

  def update
    @machine = @company.machines.find(params[:id])
    if @machine.update(machine_params)
    redirect_to member_machines_path, notice: '変更しました'
    else
      render :edit
    end
  end

  def destroy
    @machine = @company.machines.find(params[:id])
    @machine.destroy!
    redirect_to member_machines_path, notice: '削除しました'
  end
  
  private

  def get_company
    @company = current_user.company
  end
end
